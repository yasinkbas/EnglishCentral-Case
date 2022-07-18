import ProjectDescription

let project = Project(
    name: "CoreViewKit",
    organizationName: "com.yasinkbas.CoreViewKit",
    targets: [
        Target(
            name: "CoreViewKit",
            platform: .iOS,
            product: .framework,
            bundleId: "com.yasinkbas.CoreViewKit",
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
