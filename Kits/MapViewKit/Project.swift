import ProjectDescription

let project = Project(
    name: "MapViewKit",
    organizationName: "com.yasinkbas.MapViewKit",
    targets: [
        Target(
            name: "MapViewKit",
            platform: .iOS,
            product: .framework,
            bundleId: "com.yasinkbas.MapViewKit",
            deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone]),
            infoPlist: .default,
            sources: [
                "Sources/**/*.swift",
                "Sources/**/*.m"
            ],
        dependencies: [
            .project(target: "CommonKit", path: .relativeToManifest("../../Kits/CommonKit")),
            .project(target: "CoreViewKit", path: .relativeToManifest("../../Kits/CoreViewKit")),
            .package(product: "UILab")
        ]),
        Target(
            name: "MapViewKitTests",
            platform: .iOS,
            product: .unitTests,
            bundleId: "com.yasinkbas.MapViewKitTests",
            deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone]),
            infoPlist: .default,
            sources: [
                "UnitTests/**"
            ],
            dependencies: [
                .target(name: "MapViewKit")
            ]
        )
    ])
