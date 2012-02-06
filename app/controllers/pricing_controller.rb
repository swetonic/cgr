class PricingController < ApplicationController 

  layout CURRENT_LAYOUT

  def index
    @prices = [['Laundered Shirts', '1.95'],
          ['Blouses/Shirts', '8.50'],
          ['Dresses', '12.50 and up'],
          ['Pants', '9.50'],
          ['Blazers', '8.50'],
          ['Sweaters', '7.50 and up'],
          ['Coats', '14.50 and up'],
          ['Wash & Fold Laundry', '1.75 per pound'],
    ]
    
    @blankets = [ ['Twin', '15'],
      ['Queen', '25'],
      ['King', '35']
    ]

    @comforters = [ ['Twin', '25'],
      ['Queen', '35'],
      ['King', '45']
    ]


    @alterations = [ ['Pant Hems', '16'],
      ['Skirt Hem', '16']
    ]
    
    #@prices = PRICES
#    @categories = {}
#    CleaningCategory.find(:all).each do |category|
#      @categories[category.name] = category
#    end
  end
  
end



