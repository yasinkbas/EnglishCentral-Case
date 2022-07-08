import ProjectDescription

let project = Project(
    name: "MapModule",
    organizationName: "com.yasinkbas.MapModule",
    targets: [
        Target(
            name: "MapModule",
            platform: .iOS,
            product: .framework,
            bundleId: "com.yasinkbas.MapModule",
            infoPlist: .default,
            sources: [
                "Sources/**/*.swift",
                "Sources/**/*.m",
                "Sources/**/*.docc"
            ])
    ])
