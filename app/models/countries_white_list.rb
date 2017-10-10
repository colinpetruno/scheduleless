class CountriesWhiteList
  def self.allowed
    %w(AT AU BS BB BE CA CK DE GD IE JM LI LU NZ KN VC SG CH TT GB US)
  end

  def self.priorities
    %w(CA GB US DE)
  end
end
