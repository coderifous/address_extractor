class AddressExtractor
  class << self

    # Returns hash for address if address found.
    # Returns nil if no address found.
    def first_address(string)
      hashify_results string.scan(ADDRESS_PATTERN).first
    end

    # Returns array of hashes for each address found.
    # Returns empty array if no addresses found.
    def find_addresses(string)
      string.scan(ADDRESS_PATTERN).collect { |a| hashify_results(a) }.compact
    end
    
    # Pass it a block that recieves 2 parameters: 
    #   address hash
    #   matched address string ($&)
    # Whatever your block returns will be used for the substition.
    # Returns new string with substition applied to first identified address.
    # If no address found, returns same string unaltered.
    def replace_first_address(string)
      hash = first_address(string)
      string.sub(ADDRESS_PATTERN) do |match|
        yield(hash, $&)
      end
    end

    # Same as +replace_first_address+ but applies substition to all identified addresses.
    def replace_addresses(string)
      string.gsub(ADDRESS_PATTERN) do |match|
        hash = hashify_results match.scan(ADDRESS_PATTERN).first
        useful_address?(hash) ? yield(hash, $&) : match
      end
    end
    
  private
    
    def hashify_results(matches)
      return nil if matches.nil?
      result = { }
      capture_index = 0
      CAPTURE_MAP.each do |field|
        result[field] = matches[capture_index].to_s.chomp if matches[capture_index]
        capture_index += 1
      end
      useful_address?(result) ? result : nil
    end
    
    def useful_address?(hash)
      hash && 
      hash[:street1] && ( hash[:zip] || hash[:city] && hash[:state] )
    end
    
  end
  
  CAPTURE_MAP = [ :street1, :street2, :city, :state, :zip, :zip ]
  
  STATES = <<-EOF
    ALABAMA  AL
    ALASKA  AK
    AMERICAN SAMOA  AS
    ARIZONA  AZ
    ARKANSAS  AR
    CALIFORNIA  CA
    COLORADO  CO
    CONNECTICUT  CT
    DELAWARE  DE
    DISTRICT OF COLUMBIA  DC
    FEDERATED STATES OF MICRONESIA  FM
    FLORIDA  FL
    GEORGIA  GA
    GUAM  GU
    HAWAII  HI
    IDAHO  ID
    ILLINOIS  IL
    INDIANA  IN
    IOWA  IA
    KANSAS  KS
    KENTUCKY  KY
    LOUISIANA  LA
    MAINE  ME
    MARSHALL ISLANDS  MH
    MARYLAND  MD
    MASSACHUSETTS  MA
    MICHIGAN  MI
    MINNESOTA  MN
    MISSISSIPPI  MS
    MISSOURI  MO
    MONTANA  MT
    NEBRASKA  NE
    NEVADA  NV
    NEW HAMPSHIRE  NH
    NEW JERSEY  NJ
    NEW MEXICO  NM
    NEW YORK  NY
    NORTH CAROLINA  NC
    NORTH DAKOTA  ND
    NORTHERN MARIANA ISLANDS  MP
    OHIO  OH
    OKLAHOMA  OK
    OREGON  OR
    PALAU  PW
    PENNSYLVANIA  PA
    PUERTO RICO  PR
    RHODE ISLAND  RI
    SOUTH CAROLINA  SC
    SOUTH DAKOTA  SD
    TENNESSEE  TN
    TEXAS  TX
    UTAH  UT
    VERMONT  VT
    VIRGIN ISLANDS  VI
    VIRGINIA  VA
    WASHINGTON  WA
    WEST VIRGINIA  WV
    WISCONSIN  WI
    WYOMING  WY
  EOF
  
  STATE_REGEX = STATES.split(/\n/).collect{ |n| n.scan(/(\w.*\w)\s*([A-Z]{2})\s*$/) }.join("|")
  
  SECONDARY_UNIT_DESIGNATORS = <<-EOF
    APARTMENT APT
    BASEMENT BSMT
    BUILDING BLDG
    DEPARTMENT DEPT
    FLOOR FL
    FRONT FRNT
    HANGAR HNGR
    LOBBY LBBY
    LOT LOT
    LOWER LOWR
    OFFICE OFC
    PENTHOUSE PH
    PIER PIER
    REAR REAR
    ROOM RM
    SIDE SIDE
    SLIP SLIP
    SPACE SPC
    STOP STOP
    SUITE STE
    TRAILER TRLR
    UNIT UNIT
    UPPER UPPR
  EOF
  
  SECONDARY_UNIT_DESIGNATORS_REGEX = SECONDARY_UNIT_DESIGNATORS.split(/\n/).collect{ |n| n.scan(/(\w+)\s*(\w+)\s*$/) }.join("|")

  ADDRESS_PATTERN = /
    (
      \d+                           # A few numbers
      \s+
      (?:[A-Za-z'.-]+\s?){1,3}      # Followed by a street name
    )
    \s* ,?  \s*                     
    (
      (?:\d+\s+)?                   # a secondary unit, optionally
      (?:#{SECONDARY_UNIT_DESIGNATORS_REGEX})
      (?:\s+\d+)?
    )?
    \s* ,?  \s*                     # a comma, optionally
    (?:
      (?:
        ((?:[A-Za-z]+\s?){1,3})     # city
        \s+
        \b(#{STATE_REGEX})\b        # state
        \s* ,? \s*                  # a comma, optionally
        (\d{6})?                    # a zip code, optionally
      )                            
      |                             # or, instead of city and state
      (\d{6})?                      # a lone zip code will do
    )
  /xi
end