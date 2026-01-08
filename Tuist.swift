@preconcurrency import ProjectDescription

let tuist = Tuist(
  project: .tuist(
    compatibleXcodeVersions: .all,
    swiftVersion: nil,
    plugins: [ ],
    generationOptions: .options(),
    installOptions: .options())
)
