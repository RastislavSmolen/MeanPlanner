
//let interaction = UIContextMenuInteraction(delegate: self)
//sideMenuButton.addInteraction(interaction)
//let configuration = UIContextMenuConfiguration(
//  identifier: "MyIdentifier" as NSCopying,
//  previewProvider: {
//    // Return a view controller for preview or nil
//    return nil
//  },
//  actionProvider: { suggestedActions in
//    // Return a UIMenu or nil
//    return nil
//})
//extension HomeScreenViewController: UIContextMenuInteractionDelegate {
//    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
//      configurationForMenuAtLocation location: CGPoint)
//      -> UIContextMenuConfiguration? {
//
//      let favorite = UIAction(title: "Favorite",
//        image: UIImage(systemName: "heart.fill")) { _ in
//        // Perform action
//      }
//
//      let share = UIAction(title: "Share",
//        image: UIImage(systemName: "square.and.arrow.up.fill")) { action in
//        // Perform action
//      }
//
//      let delete = UIAction(title: "Delete",
//        image: UIImage(systemName: "trash.fill"),
//        attributes: [.destructive]) { action in
//         // Perform action
//       }
//
//       return UIContextMenuConfiguration(identifier: nil,
//         previewProvider: nil) { _ in
//         UIMenu(title: "Actions", children: [favorite, share, delete])
//       }
//    }
//}
