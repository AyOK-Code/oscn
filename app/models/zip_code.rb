class ZipCode < ApplicationRecord
  ZIPS_OKLAHOMA_COUNTY = %w[
    73003 73007 73008 73013 73020 73034 73045 73049 73054 73066 73083 73084 73097 73101 73102 73103 73104 73105
    73106 73107 73108 73109 73110 73110 73111 73112 73113 73114 73115 73115 73116 73116 73117 73118 73119 73120
    73120 73121 73122 73122 73123 73123 73124 73125 73126 73127 73128 73129 73130 73130 73131 73132 73132 73134
    73135 73135 73136 73137 73140 73140 73141 73142 73143 73144 73145 73145 73146 73147 73148 73149 73150 73151
    73152 73153 73153 73154 73155 73156 73157 73159 73162 73163 73164 73167 73169 73172 73177 73178 73179 73180
    73189 73195
  ]

  has_many :datas, class_name: 'Census::Data', as: :area, dependent: :destroy

  validates :name, presence: true
end
