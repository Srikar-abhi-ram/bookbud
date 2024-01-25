import 'package:bookbuddy/themes/theme_manager.dart';
import 'package:flutter/material.dart';

class Books extends StatefulWidget {
  final List<Map<String, dynamic>> booklist;

  const Books({Key? key, required this.booklist}) : super(key: key);

  @override
  State<Books> createState() => _BooksState();
}


class _BooksState extends State<Books> {
  var booklist = [
    {
      "title": "Classical Mythology",
      "author": 'Mark P. O. Morford',
      'image': 'images/ClassicalMythology.jpg',
      'availability': 'unavailable'
    },
    {
      "title": "Clara Callan",
      "author": 'Richard Bruce Wright',
      'image': 'images/ClaraCallan.jpg',
      'availability': 'available'
    },
    {
      "title": "Flu: The Story of the Great Influenza",
      "author": 'Gina Bari',
      'image': 'images/Flu.jpg',
      'availability': 'unavailable'
    },
    {
      "title": "The Middle Stories",
      "author": 'Sheila Heti',
      'image': 'images/TheMiddleStories.jpg',
      'availability': 'available'
    },
    {
      "title": "The Mummies of Urumchi",
      "author": 'E.J.W.Barber',
      'image': 'images/TheMummiesofUrumchi.jpg',
      'availability': 'available'
    },
    {
      "title": "What If?",
      "author": 'Robert Cowley',
      'image': 'images/Whatif.jpg',
      'availability': 'unavailable'
    },
    {
      "title": "Pleading Guilty",
      "author": 'Scott Turow',
      'image': 'images/Pleadingguilty.jpg',
      'availability': 'available'
    },
    {
      "title": " Where You'll Find Me",
      "author": 'Ann Beattie',
      'image': 'images/WhereYoullFindMe.jpg',
      'availability': 'available'
    },
    {
      "title": "Nights Below Station Street ",
      "author": 'David Richards',
      'image': 'images/Nights.jpg',
      'availability': 'available'
    },
    {
      "title": "Hitler's Secret Bankers",
      "author": 'Adam Lebor',
      'image': 'images/Hitlerssecret.jpg',
      'availability': 'available'
    },
    {
      "title": " Jane Doe",
      "author": 'R.J.Kaiser',
      'image': 'images/Janedoe.jpg',
      'availability': 'unavailable'
    }
  ];

 List<Map<String, dynamic>> _foundbooks =[] ;

@override
  void initState() {
    _foundbooks = booklist;
    // TODO: implement initState
    super.initState();
  }


void _runFilter(String enteredKeyword) {
  List<Map<String, dynamic>> _result = [];

  if (enteredKeyword.isEmpty) {
    _result = booklist;
  } else {
    _result = booklist.where((book) =>
        book['author']!.toLowerCase().contains(enteredKeyword.toLowerCase()) ||
        book['title']!.toLowerCase().contains(enteredKeyword.toLowerCase())||
        book['availability']!.toLowerCase().contains(enteredKeyword.toLowerCase())
    ).toList();
  }

  setState(() {
    _foundbooks = _result;
  });
}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         TextField(
          onChanged: (value)=> _runFilter(value),
          decoration: InputDecoration(labelText: 'search by author or by book', suffixIcon: Icon(Icons.search)),
          ),

        const SizedBox(height: 20),

Expanded(
  child: ListView.builder(
          itemCount: _foundbooks.length,
          itemBuilder: (BuildContext context, int index) {
            return SingleBook(
              bookname: _foundbooks[index]['title'],
              bookauth: _foundbooks[index]['author'],
              bookimg: _foundbooks[index]['image'],
              bookavail: _foundbooks[index]['availability'],
            );
          },
        ),
),

      ]
    
    );
  }
}

ThemeManager _themeManager = ThemeManager();
class SingleBook extends StatelessWidget {
  const SingleBook({Key? key, this.bookname, this.bookauth, this.bookimg, this.bookavail}) : super(key: key);
  final bookname;
  final bookauth;
  final bookimg;
  final bookavail;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Container( // Set the desired width for the card
        child: Hero(
          tag: bookname,
          child: Material(
            
            child: InkWell(
              onTap: () {
                // Handle the tap action
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100, // Adjust the width as needed
                    height: 150, // Adjust the height as needed
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.asset(
                        bookimg,
                        fit: BoxFit.cover, // Use BoxFit.cover to maintain aspect ratio
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          Text(
                            bookname,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'By : $bookauth',
                            style: TextStyle(fontSize: 13),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Availability: ',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold ),
                          ),Text(
  '$bookavail',
  style: TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.bold,
    color: bookavail == 'available' ? Colors.green : Colors.red,
  ),
),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
