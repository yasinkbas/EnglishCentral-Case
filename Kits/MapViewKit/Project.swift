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
            infoPlist: .default,
            sources: [
                "Sources/**/*.swift",
                "Sources/**/*.m"
            ],
        dependencies: [
            .project(target: "CommonKit", path: .relativeToManifest("../../Kits/CommonKit")),
            .package(product: "UILab")
        ])
    ])
