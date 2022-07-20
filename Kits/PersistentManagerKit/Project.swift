import ProjectDescription

let project = Project(
    name: "PersistentManagerKit",
    organizationName: "com.yasinkbas.PersistentManagerKit",
    targets: [
        Target(
            name: "PersistentManagerKit",
            platform: .iOS,
            product: .framework,
            bundleId: "com.yasinkbas.PersistentManagerKit",
            infoPlist: .default,
            sources: [
                "Sources/**/*.swift",
                "Sources/**/*.m",
                "Sources/**/*." // TODO: coredata model file
            ],
        dependencies: [
            .project(target: "CommonKit", path: .relativeToManifest("../../Kits/CommonKit"))
        ])
    ])
