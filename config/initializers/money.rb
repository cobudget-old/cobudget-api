MoneyRails.configure do |config|
  config.register_currency = {
    :priority            => 1,
    :iso_code            => "XBT",
    :name                => "Bitcoin",
    :symbol              => "Ƀ",
    :symbol_first        => true,
    :subunit             => "Subcent",
    :subunit_to_unit     => 10000,
    :thousands_separator => ",",
    :decimal_mark        => "."
  }

  config.register_currency = {
    :priority            => 1,
    :iso_code            => "ETH",
    :name                => "Ethereum",
    :symbol              => "Ξ",
    :symbol_first        => true,
    :subunit             => "Subcent",
    :subunit_to_unit     => 10000,
    :thousands_separator => ",",
    :decimal_mark        => "."
  }
end
