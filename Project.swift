import ProjectDescription

let packages: [Package] = [
    Package.remote(url: "https://github.com/yasinkbas/NLab.git", requirement: .upToNextMajor(from: "1.1.1")),
    Package.remote(url: "https://github.com/yasinkbas/UILab.git", requirement: .upToNextMajor(from: "0.3.3"))
]

let dependencies: [TargetDependency] = {
    var dependencies: [TargetDependency] = []
    
    // External
    dependencies.append(contentsOf: [
        .package(product: "NLab"),
        .package(product: "UILab"),
    ])
    
    // Internal Kits
    dependencies.append(contentsOf: [
        .project(target: "CommonKit", path: .relativeToManifest("Kits/CommonKit")),
        .project(target: "NetworkKit", path: .relativeToManifest("Kits/NetworkKit")),
        .project(target: "DependencyManagerKit", path: .relativeToManifest("Kits/DependencyManagerKit")),
        .project(target: "MapViewKit", path: .relativeToManifest("Kits/MapViewKit")),
        .project(target: "CoreViewKit", path: .relativeToManifest("Kits/CoreViewKit"))
    ])
    
    // Internal Modules
    dependencies.append(contentsOf: [
        .project(target: "HomeModule", path: .relativeToManifest("Modules/HomeModule"))
    ])
    return dependencies
}()

let appTarget = Target(
    name: "EnglishCentral-Case",
    platform: .iOS,
    product: .app,
    bundleId: "com.yasinkbas.EnglishCentral-Case",
    infoPlist: .extendingDefault(with: [
        "UILaunchScreen": [:],
        "NSLocationWhenInUseUsageDescription" : "Needs your location to show you near places"
    ]),
    sources: [
        "EnglishCentral-Case/**/*.swift",
        "EnglishCentral-Case/**/*.m"
    ],
    resources: [
        "APIKeys.plist",
        "EnglishCentral-Case/Resources/**",
        "EnglishCentral-Case/**/*.storyboard", // launch storyboard
        "EnglishCentral-Case/**/*.xib", // not necessary but can stay for now
        "EnglishCentral-Case/**/*.xcassets",
    ],
    dependencies: dependencies
)

let unitTestTarget = Target(
    name: "EnglishCentral-CaseTests",
    platform: .iOS,
    product: .unitTests,
    bundleId: "com.yasinkbas.EnglishCentral-CaseTests",
    infoPlist: .default,
    sources: ["UnitTests/**"],
    dependencies: [.target(name: "EnglishCentral-Case")]
)

let uiTestTarget = Target(
    name: "EnglishCentral-CaseTests",
    platform: .iOS,
    product: .uiTests,
    bundleId: "com.yasinkbas.EnglishCentral-CaseTests",
    infoPlist: "EnglishCentral-CaseTests/Resources/Info.plist",
    sources: ["EnglishCentral-CaseTests/Source/**"],
    dependencies: [.target(name: "EnglishCentral-Case")]
)

let project = Project(
    name: "EnglishCentral-Case",
    organizationName: "com.yasinkbas.EnglishCentral-Case",
    packages: packages,
    targets: [
        appTarget,
        unitTestTarget,
        //        uiTestTarget
    ]
)
