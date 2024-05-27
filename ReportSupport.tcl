#  File Name:         ReportSupport.tcl
#  Purpose:           Convert OSVVM YAML build reports to HTML
#  Revision:          OSVVM MODELS STANDARD VERSION
#
#  Maintainer:        Jim Lewis      email:  jim@synthworks.com
#  Contributor(s):
#     Jim Lewis      email:  jim@synthworks.com
#
#  Description
#    Convert OSVVM YAML build reports to HTML
#    Visible externally:  Report2Html
#
#  Developed by:
#        SynthWorks Design Inc.
#        VHDL Training Classes
#        OSVVM Methodology and Model Library
#        11898 SW 128th Ave.  Tigard, Or  97223
#        http://www.SynthWorks.com
#
#  Revision History:
#    Date      Version    Description
#    05/2024   2024.05    Initial Revision
#
#
#  This file is part of OSVVM.
#
#  Copyright (c) 2024 by SynthWorks Design Inc.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

package require yaml

# -------------------------------------------------
# CreateOsvvmReportHeader
#
proc CreateOsvvmReportHeader {ResultsFile ReportName {RelativePath ""}} {
  
  puts $ResultsFile "<!DOCTYPE html>"
  puts $ResultsFile "<html lang=\"en\">"
  puts $ResultsFile "<head>"
  
  LinkCssFiles $ResultsFile $RelativePath
  
  puts $ResultsFile "  <title>$ReportName</title>"
  puts $ResultsFile "</head>"
  puts $ResultsFile "<body>"
  puts $ResultsFile "<header>"
  puts $ResultsFile "  <h1>$ReportName</h1>"
  puts $ResultsFile "</header>"
  puts $ResultsFile "<main>"
}

# -------------------------------------------------
# CreateOsvvmReportFooter
#
proc CreateOsvvmReportFooter {ResultsFile} {
  puts $ResultsFile "</main>"
  puts $ResultsFile "<footer>"
  puts $ResultsFile "  <hr />"
  # ::osvvm::OsvvmVersion is appropriate here.  The two versions should match.
	puts $ResultsFile "  <p class=\"generated-by-osvvm\">Generated by OSVVM-Scripts ${::osvvm::OsvvmVersion} on [clock format [clock seconds] -format {%Y-%m-%d - %H:%M:%S (%Z)}].</p>"
  puts $ResultsFile "</footer>"
  puts $ResultsFile "</body>"
  puts $ResultsFile "</html>"
}

# -------------------------------------------------
# FindCssPngFiles
#
# proc FindCssPngFiles {BaseDirectory CssTargetSubdirectory} {
#   variable Report2CssFiles
#   variable Report2PngFile
#   
#   # Note files are linked into the HTML in glob order (alphabetical but may be OS dependent WRT upper case)
#   set CssFiles [glob -nocomplain [file join ${BaseDirectory} ${CssTargetSubdirectory} *.css]]
#   set Report2CssFiles ""
#   if {$CssFiles ne ""} {
#     foreach CssFileWithPath ${CssFiles} {
#       set CssFile [file join $CssTargetSubdirectory [file tail $CssFileWithPath]]
#       lappend Report2CssFiles $CssFile
#     }
#   }
#   
#   # There should only be one *.png file.
#   set PngFiles [glob -nocomplain [file join ${BaseDirectory} ${CssTargetSubdirectory} *.png]]
#   set Report2PngFile ""
#   if {$PngFiles ne ""} {
#     foreach PngFileWithPath ${PngFiles} {
#       set PngDestFile [file join $CssTargetSubdirectory [file tail $PngFileWithPath]]
#     }
#   }
#   # There should be only one PNG file, so only copy the last one we find.
# #  file copy -force ${PngFileWithPath} [file join $BaseDirectory $CssTargetSubdirectory $PngFile]
#   set Report2PngFile $PngDestFile
# }

# -------------------------------------------------
# LinkCssFiles
#
proc LinkCssFiles {ResultsFile {RelativePath ""}} {
  variable Report2CssFiles
  
  # Note files are linked into the HTML in glob order (alphabetical but may be OS dependent WRT upper case)
  if {$Report2CssFiles ne ""} {
    foreach CssFile ${Report2CssFiles} {
      puts $ResultsFile "  <link rel=\"stylesheet\" href=\"[file join $RelativePath $CssFile]\">"
    }
  }
}

# -------------------------------------------------
# LinkLogoFile
#
proc LinkLogoFile {ResultsFile {RelativePath ""}} {
  variable Report2PngFile
  
  puts $ResultsFile "    <div class=\"summary-logo\">"
	puts $ResultsFile "    	 <img id=\"logo\" src=\"[file join $RelativePath $Report2PngFile]\" alt=\"OSVVM logo\">"
  puts $ResultsFile "    </div>"
}

# -------------------------------------------------
# GetOsvvmPathSettings
#
proc GetOsvvmPathSettings {TestDict} {
  set SettingsInfoDict                         [dict get $TestDict OsvvmSettingsInfo]
  variable Report2BaseDirectory                [dict get $SettingsInfoDict BaseDirectory]
  variable Report2ReportsSubdirectory          [dict get $SettingsInfoDict ReportsSubdirectory]
  variable Report2CssSubdirectory              [dict get $SettingsInfoDict CssSubdirectory]
  variable Report2SimulationLogFile            [dict get $SettingsInfoDict SimulationLogFile]
  variable Report2SimulationHtmlLogFile        [dict get $SettingsInfoDict SimulationHtmlLogFile]
  variable Report2RequirementsSubdirectory     [dict get $SettingsInfoDict RequirementsSubdirectory]
  variable Report2CoverageSubdirectory         [dict get $SettingsInfoDict CoverageSubdirectory]
  variable Report2CssFiles                     [dict get $SettingsInfoDict Report2CssFiles]
  variable Report2PngFile                      [dict get $SettingsInfoDict Report2PngFile]
}

# -------------------------------------------------
# GetTestCaseSettings
#
proc GetTestCaseSettings {SettingsFileName} {
  set TestDict  [::yaml::yaml2dict -file ${SettingsFileName}]
  variable Report2TestCaseName                 [dict get $TestDict TestCaseName        ]
  variable Report2TestSuiteName                [dict get $TestDict TestSuiteName       ]
  variable Report2BuildName                    [dict get $TestDict BuildName           ]
  variable Report2GenericList                  [dict get $TestDict GenericList         ]
  variable Report2TestCaseFileName             [dict get $TestDict TestCaseFileName    ]
  variable Report2GenericNames                 [dict get $TestDict GenericNames        ]
  variable Report2TestSuiteDirectory           [dict get $TestDict TestSuiteDirectory  ]
  variable Report2RequirementsYamlFile         [dict get $TestDict RequirementsYamlFile]
  variable Report2AlertYamlFile                [dict get $TestDict AlertYamlFile       ]
  variable Report2CovYamlFile                  [dict get $TestDict CovYamlFile         ]
  variable Report2ScoreboardFiles              [dict get $TestDict ScoreboardFiles     ]
  variable Report2ScoreboardNames              [dict get $TestDict ScoreboardNames     ]
  variable Report2TranscriptFiles              [dict get $TestDict TranscriptFiles     ]

  variable Report2TestCaseHtml [file join $Report2TestSuiteDirectory ${Report2TestCaseFileName}.html]
  
  GetOsvvmPathSettings $TestDict
}


