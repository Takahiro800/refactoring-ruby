# 6.6 説明用変数の導入
class IntroduceExplainingVariable
end

# Before < Sample
if platform.upcase.index("MAC") && browser.upcase.index("IF") && initialized? && resize > 0
  #  何かの処理
end

# After < Sample
is_mac_os = platform.upcase.index("MAC")
is_ie_browser = browser.upcase.index("IE")
was_resized = resize > 0

if is_mac_os && is_ie_browser && was_resized
  # 何かの処理
end
