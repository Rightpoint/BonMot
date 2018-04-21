module Fastlane
  module Actions
    module SharedValues
      # XCHTMLREPORT_CUSTOM_VALUE = :XCHTMLREPORT_CUSTOM_VALUE
    end

    class XchtmlreportAction < Action
      def self.run(params)
        result_bundle_path = params[:result_bundle_path]
        binary_path = params[:binary_path]

        if !File.file?(binary_path)
          UI.user_error!("xchtmlreport binary not installed! https://github.com/TitouanVanBelle/XCTestHTMLReport")
        end
        UI.message "Result bundle path: #{result_bundle_path}"

        sh "#{binary_path} -r #{result_bundle_path}"

      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Xcode-like HTML report for Unit and UI Tests"
      end

      def self.details
        "https://github.com/TitouanVanBelle/XCTestHTMLReport"
      end

      def self.available_options
        # Define all options your action supports. 
        
        # Below a few examples
        [
          FastlaneCore::ConfigItem.new(key: :result_bundle_path,
                                       description: "Path to the result bundle from scan. After running scan you can use Scan.cache[:result_bundle_path]", # a short description of this parameter
                                       verify_block: proc do |value|
                                          UI.user_error!("Bad path to the result bundle given, pass using `result_bundle_path: 'path'`") unless (value and File.directory?(value))
                                       end),
          FastlaneCore::ConfigItem.new(key: :binary_path,
                                       description: "Path to xchtmlreport binary",
                                       is_string: true, # true: verifies the input is a string, false: every kind of value
                                       default_value: "/usr/local/bin/xchtmlreport") # the default value if the user didn't provide one
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        # [
        #   ['XCHTMLREPORT_CUSTOM_VALUE', 'A description of what this value contains']
        # ]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.authors
        ["XCTestHTMLReport: TitouanVanBelle", "plugin: chrisballinger"]
      end

      def self.is_supported?(platform) 
        [:ios, :mac].include?(platform)
      end
    end
  end
end
