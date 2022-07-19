import ProjectDescription

let project = Project(
    name: "HomeModule",
    organizationName: "com.yasinkbas.HomeModule",
    targets: [
        Target(
            name: "HomeModule",
            platform: .iOS,
            product: .framework,
            bundleId: "com.yasinkbas.HomeModule",
            infoPlist: .default,
            sources: [
                "Sources/**/*.swift",
                "Sources/**/*.m",
                "Sources/**/*.docc"
            ],
            dependencies: [
                .project(target: "CommonKit", path: .relativeToManifest("../../Kits/CommonKit")),
                .project(target: "CoreViewKit", path: .relativeToManifest("../../Kits/CoreViewKit")),
                .project(target: "DependencyManagerKit", path: .relativeToManifest("../../Kits/DependencyManagerKit")),
                .project(target: "NetworkKit", path: .relativeToManifest("../../Kits/NetworkKit")),
                .project(target: "MapViewKit", path: .relativeToManifest("../../Kits/MapViewKit")),
                .package(product: "NLab"),
                .package(product: "UILab")
            ]),
        Target(
            name: "HomeModuleTests",
            platform: .iOS,
            product: .unitTests,
            bundleId: "com.yasinkbas.HomeModuleTests",
            infoPlist: .default,
            sources: [
                "UnitTests/**"
            ],
            resources: [
                "UnitTests/**"
            ],
            dependencies: [

            ])
    ])
