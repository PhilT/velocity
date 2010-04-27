COLORS = %w(#448 #44c #484 #488 #48c #4c4 #4c8 #4cc #844 #848 #84c #884 #88c #8c4 #8c8 #8cc #c44 #c48 #c4c #c84 #c88 #c8c #cc4 #cc8)

def color_index model
  (model.id - 1) % COLORS.size
end

