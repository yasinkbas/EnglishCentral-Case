import ProjectDescription

let project = Project(
    name: "NetworkKit",
    organizationName: "com.yasinkbas.NetworkKit",
    targets: [
        Target(
            name: "NetworkKit",
            platform: .iOS,
            product: .framework,
            bundleId: "com.yasinkbas.NetworkKit",
            infoPlist: .default,
            sources: [
                "Sources/**/*.swift",
                "Sources/**/*.m"
            ],
        dependencies: [
            .project(target: "CommonKit", path: .relativeToManifest("../../Kits/CommonKit")),
            .package(product: "NLab")
        ])
    ])
