//
//  ViewController.swift
//  testCameras
//
//  Created by Дмитрий Цветков on 12.08.2023.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    @IBOutlet weak var segmentControl: SquareSegmentedControl!
    @IBOutlet weak var underlineCameras: UIView!
    @IBOutlet weak var underlineDoors: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(nil, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    var dataSource: UICollectionViewDiffableDataSource<MSection, MItem>?
    var changeData = true
    var networkManager = NetworkManager()
    
    let realm = try! Realm()
    var realmItems: Results<Cameras>!
    
    
    var sections: [MSection] = []
    var sections1: [MSection] = []
    var sections2: [MSection] = []
    
    var cam: Cam?
    var door: Door?
    
    let group = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.refreshControl = myRefreshControl
        realmItems = realm.objects(Cameras.self)
        
        if realmItems.count != 0 {
            feelingSection1And2()
            baseConf()
        } else {
            group.enter()
            getCams()

            group.enter()
            getDoors()
            
            group.notify(queue: .main) {
                self.fillingSections()
                self.baseConf()
            }
        }
    }
    
    func layoutConfig() {
        let layout = UICollectionViewCompositionalLayout() { sectionIndex, layoutEnvironment in
            
            var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            configuration.headerMode = sectionIndex == 0 ? .supplementary : .none
           
            configuration.trailingSwipeActionsConfigurationProvider = { [unowned self] (indexPath) in
                guard let _ = dataSource?.itemIdentifier(for: indexPath) else { return nil }
                let action1 = UIContextualAction(style: .normal, title: "") { (action, view, completion) in
                    completion(true)
                }
                action1.backgroundColor = .white
                action1.image = UIImage(named: "star 1")
                
                if changeData == false {
                    let action2 = UIContextualAction(style: .normal, title: "") { (action, view, completion) in
                        try! self.realm.write {
                            self.realmItems[0].items2[indexPath.item].name = "\(self.realmItems[0].items2[indexPath.item].name) + new"
                        }
                        self.sections2[0].items[indexPath.item].name = "\(self.sections2[0].items[indexPath.item].name) + new"
                        self.sections[0].items[indexPath.item].name = "\(self.sections[0].items[indexPath.item].name) + new"
                        self.reloadData()
                        completion(true)
                    }
                    action2.backgroundColor = .white
                    action2.image = UIImage(named: "edit")
                    
                    return UISwipeActionsConfiguration(actions: [action1, action2])
                }
                return UISwipeActionsConfiguration(actions: [action1])

            }
            
            let section = NSCollectionLayoutSection.list(using: configuration,
                                                         layoutEnvironment: layoutEnvironment)
            section.interGroupSpacing = 20
            
            return section
        }
        collectionView.collectionViewLayout = layout
    }
    
    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<MSection, MItem>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            switch self.sections[indexPath.section].type {
            case "First":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell
                cell?.createImage(imageStr: self.sections[indexPath.section].items[indexPath.item].snapshot)
                cell?.createLabel(text: self.sections[indexPath.section].items[indexPath.item].name)
                cell?.createRec(show: self.sections[indexPath.section].items[indexPath.item].rec)
                cell?.createFav(show: self.sections[indexPath.section].items[indexPath.item].favorites)
                cell?.layer.cornerRadius = 10
                cell?.backgroundColor = .brown
                return cell ?? UICollectionViewCell()
            case "Second":
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DoorCollectionViewCell.identifier, for: indexPath) as? DoorCollectionViewCell
                    cell?.createImage(isHidden: false)
                    
                if self.sections[indexPath.section].items[indexPath.item].snapshot != "" {
                    cell?.createMainImage(isHidden: false, imageStr: self.sections[indexPath.section].items[indexPath.item].snapshot)
                    cell?.createLabel(text: self.sections[indexPath.section].items[indexPath.item].name, textOnline: "В сети")
                } else {
                    cell?.createLabel(text: self.sections[indexPath.section].items[indexPath.item].name, textOnline: "")
                }
                
                    cell?.backgroundColor = .brown
                    cell?.layer.cornerRadius = 10
                    return cell ?? UICollectionViewCell()
            default:
                return UICollectionViewCell()
            }
        })
    
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CustomHeader.identifier, for: indexPath) as? CustomHeader else { return nil }
            guard let firstItem = self?.dataSource?.itemIdentifier(for: indexPath) else { return nil }
            guard let section = self?.dataSource?.snapshot().sectionIdentifier(containingItem: firstItem) else { return nil }

            sectionHeader.createLabel(text: section.title)
            return sectionHeader
        }
    }
    
    func reloadData() {
        if sections[0].items.count != 0 {
            var snapshot = NSDiffableDataSourceSnapshot<MSection, MItem>()

            snapshot.appendSections(sections)
            for section in sections {
                snapshot.appendItems(section.items, toSection: section)
            }
            dataSource?.apply(snapshot)
        }
    }
}

// MARK: - work with API
extension ViewController {
    func getCams() {
        networkManager.getCams { res in
            switch res {
            case .success(let cam):
                if let cam = cam {
                    self.cam = cam
                    self.group.leave()
                }
            case .failure(let error):
                print(error)
                self.group.leave()
            }
        }
    }
    
    func getDoors() {
        networkManager.getDoors { res in
            switch res {
            case .success(let door):
                if let door = door {
                    self.door = door
                    self.group.leave()
                }
            case .failure(let error):
                print(error)
                self.group.leave()
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageView: UIImageView = UIImageView()
        imageView.load(urlString: sections[indexPath.section].items[indexPath.item].snapshot)
        configureSheet(image: imageView.image ?? UIImage())
    }
}

// MARK: - Feeling sections
extension ViewController {
    func feelingSection1And2() {
        var item: [MItem] = []
        for i in realmItems[0].items {
            item.append(MItem(snapshot: i.snapshot, name: i.name, room: i.room, favorites: i.favorites, rec: i.rec))
        }
        self.sections1.append(MSection(type: "First", title: realmItems[0].room, items: item))
        
        var item2: [MItem] = []
        for i in realmItems[0].items2 {
            item2.append(MItem(snapshot: i.snapshot, name: i.name, room: i.room, favorites: i.favorites, rec: i.rec))
        }
        self.sections2.append(MSection(type: "Second", title: "", items: item2))
    }
    
    func baseConf() {
        self.sections.append(contentsOf: self.sections1)
        self.configureSegmentControl()
        self.layoutConfig()
        self.collectionView.delegate = self

        self.createDataSource()
        self.reloadData()
    }
    
    func fillingSections() {
        let itemsRealm = Cameras()
        
        var items: [MItem] = []
        var roomName: String = ""
        if let cameras = self.cam?.data?.cameras {
            for i in cameras {
                items.append(MItem(snapshot: i.snapshot ?? "", name: i.name ?? "", room: i.room ?? "", favorites: i.favorites ?? false, rec: i.rec ?? false))
                itemsRealm.items.append(Item(value: [i.snapshot ?? "", i.name ?? "", i.room ?? "", i.favorites ?? false, i.rec ?? false] as [Any]))
                if let room = i.room {
                    roomName = room
                    itemsRealm.room = roomName
                }
            }
        }
        self.sections1.append(MSection(type: "First", title: roomName, items: items))

        var items2: [MItem] = []
        if let doorData = self.door?.data {
            for i in doorData {
                items2.append(MItem(snapshot: i.snapshot ?? "", name: i.name ?? "", room: "", favorites: i.favorites ?? false, rec: false))
                itemsRealm.items2.append(Item(value: [i.snapshot ?? "", i.name ?? "", i.room ?? "", i.favorites ?? false, false] as [Any]))
            }
        }

        try! self.realm.write {
            self.realm.add(itemsRealm)
        }
        
        self.sections2.append(MSection(type: "Second", title: "", items: items2))
    }
    
    func configureSheet(image: UIImage) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sheetViewController = storyboard.instantiateViewController(withIdentifier: "SheetVC") as? SheetVC
        let viewController = storyboard.instantiateViewController(withIdentifier: "SecondVC") as? SecondVC
        viewController?.modalPresentationStyle = .fullScreen
        
        viewController?.image = image
        sheetViewController?.secondVC = viewController
        
        if let sheet = sheetViewController?.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                0.1 * context.maximumDetentValue
            }), .large()]
            sheet.largestUndimmedDetentIdentifier = .large
        }
    
        self.navigationController?.pushViewController(viewController ?? UIViewController(), animated: true)
        viewController?.present(sheetViewController ?? UIViewController(), animated: true)
    }
}

// MARK: - Segment control
extension ViewController {
    func configureSegmentControl() {
        segmentControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segmentControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        segmentControl.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        segmentControl.layer.shadowOpacity = 1
        segmentControl.layer.shadowOffset = .zero

        segmentControl.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0, y: segmentControl.bounds.height, width: segmentControl.bounds.width, height: 2)).cgPath
        segmentControl.layer.shouldRasterize = true
        segmentControl.layer.rasterizationScale = UIScreen.main.scale
    }
    
    @IBAction func tapOnSegmentControl(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            changeData = true
            underlineCameras.backgroundColor = #colorLiteral(red: 0, green: 0.7215686275, blue: 0.968627451, alpha: 1)
            underlineDoors.backgroundColor = .clear
            sections.removeAll()
            sections.append(contentsOf: sections1)
            reloadData()
        case 1:
            changeData = false
            underlineCameras.backgroundColor = .clear
            underlineDoors.backgroundColor = #colorLiteral(red: 0, green: 0.7235224843, blue: 0.9667233825, alpha: 1)
            sections.removeAll()
            sections.append(contentsOf: sections2)
            reloadData()
            
        default:
            print("")
        }
    }
}

// MARK: - Refresh
extension ViewController {
    @objc private func refresh(sender: UIRefreshControl) {
        group.enter()
        getCams()

        group.enter()
        getDoors()
        
        group.notify(queue: .main) {
            self.sections = []
            if self.changeData == true {
                self.group.enter()

                self.sections1 = []
                self.getCams()
                
                let itemsRealm = Cameras()
                
                var items: [MItem] = []
                var roomName: String = ""
                if let cameras = self.cam?.data?.cameras {
                    for i in cameras {
                        items.append(MItem(snapshot: i.snapshot ?? "", name: i.name ?? "", room: i.room ?? "", favorites: i.favorites ?? false, rec: i.rec ?? false))
                        itemsRealm.items.append(Item(value: [i.snapshot ?? "", i.name ?? "", i.room ?? "", i.favorites ?? false, i.rec ?? false] as [Any]))
                        if let room = i.room {
                            roomName = room
                            itemsRealm.room = roomName
                        }
                    }
                }
                self.sections1.append(MSection(type: "First", title: roomName, items: items))
                
                
                self.sections.append(contentsOf: self.sections1)
                self.reloadData()
                
            } else {
                self.group.enter()
                self.sections2 = []
                self.getDoors()
                
                let itemsRealm = Cameras()
                var items2: [MItem] = []
                if let doorData = self.door?.data {
                    for i in doorData {
                        items2.append(MItem(snapshot: i.snapshot ?? "", name: i.name ?? "", room: "", favorites: i.favorites ?? false, rec: false))
                        itemsRealm.items2.append(Item(value: [i.snapshot ?? "", i.name ?? "", i.room ?? "", i.favorites ?? false, false] as [Any]))
                    }
                }

                try! self.realm.write {
                    self.realm.add(itemsRealm)
                }
                
                self.sections2.append(MSection(type: "Second", title: "", items: items2))
                
                
                self.sections.append(contentsOf: self.sections2)
                self.reloadData()
            }
            sender.endRefreshing()
        }
    }
}

