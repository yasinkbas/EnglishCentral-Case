import ProjectDescription

let projectName = "TuistDemoApp"
let bundleId = "com.yasinkbas.\(projectName)"

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
        .project(target: "CoreViewKit", path: .relativeToManifest("Kits/CoreViewKit")),
        .project(target: "PersistentManagerKit", path: .relativeToManifest("Kits/PersistentManagerKit"))
    ])
    
    // Internal Modules
    dependencies.append(contentsOf: [
        .project(target: "HomeModule", path: .relativeToManifest("Modules/HomeModule"))
    ])
    return dependencies
}()

let appTarget = Target(
    name: projectName,
    platform: .iOS,
    product: .app,
    bundleId: bundleId,
    deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone]),
    infoPlist: .extendingDefault(with: [
        "UILaunchScreen": [:],
        "NSLocationWhenInUseUsageDescription" : "Needs your location to show you near places"
    ]),
    sources: [
        "\(projectName)/**/*.swift",
        "\(projectName)/**/*.m"
    ],
    resources: [
        "APIKeys.plist",
        "\(projectName)/Resources/**",
        "\(projectName)/**/*.storyboard", // launch storyboard
        "\(projectName)/**/*.xcassets",
    ],
    dependencies: dependencies
)

let project = Project(
    name: projectName,
    organizationName: bundleId,
    packages: packages,
    targets: [
        appTarget
    ]
)
