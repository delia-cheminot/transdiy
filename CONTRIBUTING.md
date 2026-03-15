# Contributing to Mona

First off, thank you for considering contributing to Mona! The app is currently in Alpha, and we welcome all forms of contributions—whether it's fixing bugs, adding new features, improving documentation, or reporting issues.

This document outlines the process and guidelines for contributing to this project.

## Development Workflow

We use a standard **Fork and Pull Request** workflow. To keep our main branch stable, **all pull requests from external contributors must target the `dev` branch**.

### 1. Fork & Clone
1. Fork this repository to your own GitHub account.
2. Clone your forked repository to your local machine:
   ```bash
   git clone https://github.com/YOUR-USERNAME/mona-hrt.git
   cd mona-hrt
   git checkout dev
   ```

### 2. Set Up the Environment

We have provided a script to automatically set up FVM, configure your shell, and fetch the necessary dependencies.

```bash
chmod +x setup_dev.sh
./setup_dev.sh
```
> [!NOTE]
> After running the script, you may need to restart your terminal or run `source ~/.bashrc` (or `~/.zshrc`) to use the FVM commands.

### 3. Create a Feature Branch

Create a new branch for your feature or bug fix based on `dev`. Please use descriptive names:

```bash
# or
git checkout -b fix/annoying-bug
```

### 4. Running the App
Because the project uses FVM, you must prefix all standard Flutter commands with fvm. This ensures you are using the pinned SDK rather than your system's global Flutter installation.
```bash
# Get dependencies
fvm flutter pub get

# Run the app
fvm flutter run

# Run tests
fvm flutter test
```
> [!TIP]
> If you use VS Code, the repository includes a `.vscode/settings.json` file that automatically points the IDE to the FVM SDK. If you use Android Studio, please set your Flutter SDK path to `[project_root]/.fvm/flutter_sdk`.

## Dependency Rules

Do not run `fvm flutter pub upgrade`. When fetching packages, only use `fvm flutter pub get`. This respects the `pubspec.lock` file and ensures your local environment matches the exact dependency versions used by the maintainers. If a dependency needs to be updated, it should be done in a dedicated, isolated Pull Request.

## Submitting your Pull Request

Once your changes are ready and tested locally:
1. Commit your changes with clear, descriptive commit messages.
2. Push your branch to your forked repository:
   ```bash
   git push origin your-branch-name
   ```
3. Go to the original Mona repository on GitHub and click **New Pull Request**.
4. Set the base branch to `dev` and the compare branch to your feature branch.
5. Fill out the PR description, detailing what you changed and why.

## Found a Bug?

If you find a bug in the source code, you can help us by submitting an issue to our GitHub Repository. Even better, you can submit a Pull Request with a fix!

## Need Help?

If you need any help setting up your environment or understanding the codebase, please join [Mona's Discord server](https://discord.gg/qsHzkX89vJ).

Thank you for helping make Mona better!
