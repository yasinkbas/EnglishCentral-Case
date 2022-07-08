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
            infoPlist: .default,
            sources: [
                "Sources/**/*.swift",
                "Sources/**/*.m",
                "Sources/**/*.docc"
            ], dependencies: [

            ])
    ])
