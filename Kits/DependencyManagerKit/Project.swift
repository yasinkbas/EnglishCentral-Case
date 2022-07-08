import ProjectDescription

let project = Project(
    name: "DependencyManagerKit",
    organizationName: "com.yasinkbas.DependencyManagerKit",
    targets: [
        Target(
            name: "DependencyManagerKit",
            platform: .iOS,
            product: .framework,
            bundleId: "com.yasinkbas.DependencyManagerKit",
            infoPlist: .default,
            sources: [
                "Sources/**/*.swift",
                "Sources/**/*.m"
            ], dependencies: [
                .project(target: "CommonKit", path: .relativeToManifest("../../Kits/CommonKit"))
            ])
    ])
