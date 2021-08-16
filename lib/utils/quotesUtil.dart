
import 'dart:collection';
import 'dart:math';

import 'package:movie_app/model/quotes.dart';

class QuotesUtil
{
    static  List quotes =[Quotes(quote: "I'm going to make him an offer he can't refuse.",
       film: "The Godfather"),Quotes(quote: "May the Force be with you.",
        film: "Star Wars"),Quotes(quote: "You talking to me?",
        film: "Taxi Driver"),Quotes(quote: "You're gonna need a bigger boat.",
        film: "Jaws"),Quotes( quote: "There's no place like home",
        film: "The Wizard of Oz"),Quotes(quote: "Bond. James Bond.",
        film: "Dr. No"),Quotes(quote: "Keep your friends close, but your enemies closer.",
        film: "The Godfather II")
   ];
    Random _random =Random();

    Quotes getRandomQuote()
    {
      return quotes[Random().nextInt(6)];
    }



}