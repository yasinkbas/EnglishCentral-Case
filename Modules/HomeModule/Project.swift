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
            .project(target: "DependencyManagerKit", path: .relativeToManifest("../../Kits/DependencyManagerKit")),
        ])
    ])
