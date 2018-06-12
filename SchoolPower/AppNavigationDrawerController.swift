//
//  Copyright 2018 SchoolPower Studio

//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at

//  http://www.apache.org/licenses/LICENSE-2.0

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.


import UIKit
import Material

class AppNavigationDrawerController: NavigationDrawerController {
    open override func prepare() {
        super.prepare()
        
        delegate = self
        Application.statusBarStyle = .lightContent
    }
}

extension AppNavigationDrawerController: NavigationDrawerControllerDelegate {
//    func navigationDrawerController(navigationDrawerController: NavigationDrawerController, willOpen position: NavigationDrawerPosition) {
//        print("navigationDrawerController willOpen")
//    }
//    
//    func navigationDrawerController(navigationDrawerController: NavigationDrawerController, didOpen position: NavigationDrawerPosition) {
//        print("navigationDrawerController didOpen")
//    }
//    
//    func navigationDrawerController(navigationDrawerController: NavigationDrawerController, willClose position: NavigationDrawerPosition) {
//        print("navigationDrawerController willClose")
//    }
//    
//    func navigationDrawerController(navigationDrawerController: NavigationDrawerController, didClose position: NavigationDrawerPosition) {
//        print("navigationDrawerController didClose")
//    }
//    
//    func navigationDrawerController(navigationDrawerController: NavigationDrawerController, didBeginPanAt point: CGPoint, position: NavigationDrawerPosition) {
//        print("navigationDrawerController didBeginPanAt: ", point, "with position:", .left == position ? "Left" : "Right")
//    }
//    
//    func navigationDrawerController(navigationDrawerController: NavigationDrawerController, didChangePanAt point: CGPoint, position: NavigationDrawerPosition) {
//        print("navigationDrawerController didChangePanAt: ", point, "with position:", .left == position ? "Left" : "Right")
//    }
//    
//    func navigationDrawerController(navigationDrawerController: NavigationDrawerController, didEndPanAt point: CGPoint, position: NavigationDrawerPosition) {
//        print("navigationDrawerController didEndPanAt: ", point, "with position:", .left == position ? "Left" : "Right")
//    }
//    
//    func navigationDrawerController(navigationDrawerController: NavigationDrawerController, didTapAt point: CGPoint, position: NavigationDrawerPosition) {
//        print("navigationDrawerController didTapAt: ", point, "with position:", .left == position ? "Left" : "Right")
//    }
//    
//    func navigationDrawerController(navigationDrawerController: NavigationDrawerController, statusBar isHidden: Bool) {
//        print("navigationDrawerController statusBar is hidden:", isHidden ? "Yes" : "No")
//    }
}
