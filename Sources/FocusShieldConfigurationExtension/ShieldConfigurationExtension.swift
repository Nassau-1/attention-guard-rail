import ManagedSettings
import ManagedSettingsUI
import UIKit

final class ShieldConfigurationExtension: ShieldConfigurationDataSource {
  override func configuration(shielding application: Application) -> ShieldConfiguration {
    ShieldConfiguration(
      backgroundBlurStyle: .systemUltraThinMaterialDark,
      backgroundColor: .black,
      icon: UIImage(systemName: "lock.shield"),
      title: ShieldConfiguration.Label(text: "Reminder is active", color: .white),
      subtitle: ShieldConfiguration.Label(text: "Continue in Attention Guard Rail to choose how long you want to stay.", color: .lightGray),
      primaryButtonLabel: ShieldConfiguration.Label(text: "Continue", color: .black),
      primaryButtonBackgroundColor: .white,
      secondaryButtonLabel: ShieldConfiguration.Label(text: "Stay out", color: .white)
    )
  }
}
