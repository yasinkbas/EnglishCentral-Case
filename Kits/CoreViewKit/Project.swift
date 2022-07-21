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
                .project(target: "CommonKit", path: .relativeToManifest("../../Kits/CommonKit")),
                .package(product: "UILab")
                
            ])
    ])
