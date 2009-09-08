class Boolean
  def self.parse(obj)
    %w(true t 1 y).include?(obj.to_s.downcase.strip)
  end
end

