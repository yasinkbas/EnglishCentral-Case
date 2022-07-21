import ProjectDescription

let project = Project(
    name: "CommonKit",
    organizationName: "com.yasinkbas.CommonKit",
    targets: [
        Target(
            name: "CommonKit",
            platform: .iOS,
            product: .framework,
            bundleId: "com.yasinkbas.CommonKit",
            deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone]),
            infoPlist: .default,
            sources: [
                "Sources/**/*.swift",
                "Sources/**/*.m",
                "Sources/**/*.docc"
            ],
            resources: [
                "Sources/**/*.xcassets"
            ],
            dependencies: [
                .package(product: "UILab")
            ])
    ])
