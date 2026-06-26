import ManagedSettings
import ManagedSettingsUI
import UIKit

final class ShieldConfigurationExtension: ShieldConfigurationDataSource {
  override func configuration(shielding application: Application) -> ShieldConfiguration {
    ShieldConfiguration(
      backgroundBlurStyle: .systemUltraThinMaterialDark,
      backgroundColor: .black,
      icon: UIImage(systemName: "lock.shield"),
      title: ShieldConfiguration.Label(text: "Pause first", color: .white),
      subtitle: ShieldConfiguration.Label(text: "Open Focus Home to choose how long you want to stay.", color: .lightGray),
      primaryButtonLabel: ShieldConfiguration.Label(text: "Open Focus Home", color: .black),
      primaryButtonBackgroundColor: .white,
      secondaryButtonLabel: ShieldConfiguration.Label(text: "Stay out", color: .white)
    )
  }
}

