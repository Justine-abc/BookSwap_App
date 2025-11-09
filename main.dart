import 'package:flutter/material.dart';

void main() {
  runApp(BookSwapDemoApp());
}

const Color kDarkNavy = Color(0xFF1A1A2E);
const Color kYellow = Color(0xFFFDB750);

class BookSwapDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookSwap Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: kDarkNavy,
        scaffoldBackgroundColor: kDarkNavy,
        appBarTheme: AppBarTheme(
          backgroundColor: kDarkNavy,
          elevation: 0,
        ),
        colorScheme: ColorScheme.dark(
          primary: kDarkNavy,
          secondary: kYellow,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kYellow,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          ),
        ),
      ),
      home: EntryGate(),
    );
  }
}

/// Simple mock auth gate: shows Login screen if not signed in.
/// After "login" it navigates to AppShell with bottom nav.
class EntryGate extends StatefulWidget {
  @override
  _EntryGateState createState() => _EntryGateState();
}

class _EntryGateState extends State<EntryGate> {
  bool signedIn = false;
  String userEmail = '';

  void signIn(String email) {
    setState(() {
      signedIn = true;
      userEmail = email;
    });
  }

  void signOut() {
    setState(() {
      signedIn = false;
      userEmail = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!signedIn) {
      return LoginScreen(onSignedIn: signIn);
    } else {
      return AppShell(
        userEmail: userEmail,
        onSignOut: signOut,
      );
    }
  }
}

// ------------------- Login / Signup Screens -------------------

class LoginScreen extends StatefulWidget {
  final Function(String) onSignedIn;
  LoginScreen({required this.onSignedIn});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  String message = '';

  void toggleMode() {
    setState(() {
      isLogin = !isLogin;
      message = '';
    });
  }

  void submit() {
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text;
    if (email.isEmpty || pass.isEmpty) {
      setState(() => message = 'Please fill both fields');
      return;
    }
    // Mock success — in real app you'd call Firebase Auth
    widget.onSignedIn(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkNavy,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Container(
            width: 360,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.black45, blurRadius: 12, offset: Offset(0, 6))
              ],
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.book, size: 64, color: kYellow),
                SizedBox(height: 10),
                Text('BookSwap',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                SizedBox(height: 6),
                Text('Swap your books with other students',
                    style: TextStyle(color: Colors.white70)),
                SizedBox(height: 20),
                TextField(
                  controller: emailCtrl,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white10,
                    labelText: 'Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 12),
                TextField(
                  controller: passCtrl,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white10,
                    labelText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: submit,
                  child: Text(isLogin ? 'Sign In' : 'Create Account'),
                ),
                SizedBox(height: 8),
                TextButton(
                  onPressed: toggleMode,
                  child: Text(isLogin
                      ? 'Don\'t have an account? Sign up'
                      : 'Already have an account? Sign in'),
                ),
                if (message.isNotEmpty) SizedBox(height: 8),
                if (message.isNotEmpty)
                  Text(message, style: TextStyle(color: Colors.redAccent)),
                SizedBox(height: 6),
                Text('For demo: use any email and password',
                    style: TextStyle(color: Colors.white38, fontSize: 12)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ------------------- App Shell (Bottom Nav) -------------------

class AppShell extends StatefulWidget {
  final String userEmail;
  final VoidCallback onSignOut;
  AppShell({required this.userEmail, required this.onSignOut});

  @override
  _AppShellState createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  // App-level state: list of books and user-owned book IDs.
  List<Book> books = [
    Book(
      id: 'b1',
      title: 'Data Structures & Algorithms',
      author: 'Themall V. Denmon',
      condition: 'Like New',
      imageUrl:
          'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?auto=format&fit=crop&w=400&q=60',
      ownerEmail: 'owner1@example.com',
    ),
    Book(
      id: 'b2',
      title: 'Operating Systems',
      author: 'John Doe',
      condition: 'Good',
      imageUrl:
          'https://images.unsplash.com/photo-1526336024174-e58f5cdd8e13?auto=format&fit=crop&w=400&q=60',
      ownerEmail: 'owner2@example.com',
    ),
    Book(
      id: 'b3',
      title: 'Database Systems',
      author: 'Thomas H. Cormen',
      condition: 'Used',
      imageUrl:
          'https://images.unsplash.com/photo-1532012197267-da84d127e765?auto=format&fit=crop&w=400&q=60',
      ownerEmail: 'owner3@example.com',
    ),
  ];

  // Map of chat threads (mock)
  Map<String, List<ChatMessage>> chats = {
    'Alice': [
      ChatMessage(sender: 'Alice', text: 'Hi, are you interested in trading?'),
      ChatMessage(sender: 'You', text: 'Yes, I am! When can we meet?'),
    ],
    'Bob': [
      ChatMessage(sender: 'Bob', text: 'Is the book still available?'),
    ],
  };

  // helper to add book
  void addBook(Book book) {
    setState(() {
      books.insert(0, book);
    });
  }

  // helper to add chat message
  void addChatMessage(String thread, ChatMessage message) {
    setState(() {
      chats.putIfAbsent(thread, () => []).add(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        books: books,
        onRequestSwap: (Book book) {
          // simple UI feedback
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Swap requested for "${book.title}"')));
        },
      ),
      MyListingsScreen(
        books: books,
        currentUserEmail: widget.userEmail,
        onEdit: (Book updated) {
          setState(() {
            final idx = books.indexWhere((b) => b.id == updated.id);
            if (idx != -1) books[idx] = updated;
          });
        },
        onDelete: (String id) {
          setState(() => books.removeWhere((b) => b.id == id));
        },
      ),
      ChatsListScreen(
        chats: chats,
        onOpenThread: (String name) {
          // open chat detail
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ChatThreadScreen(
                      threadName: name,
                      messages: chats[name] ?? [],
                      onSend: (msg) => addChatMessage(name, msg),
                    )),
          );
        },
      ),
      ProfileScreen(
        email: widget.userEmail,
        onSignOut: widget.onSignOut,
        onCreatePost: () {
          // quick route to create post
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PostBookScreen(
                onPost: (Book b) {
                  addBook(b);
                },
                ownerEmail: widget.userEmail,
              ),
            ),
          );
        },
      ),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: kDarkNavy,
          boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 8)],
        ),
        child: SafeArea(
          child: Row(
            children: [
              buildNavItem(Icons.home, 'Home', 0),
              buildNavItem(Icons.book, 'My Listings', 1),
              buildNavItem(Icons.chat_bubble, 'Chats', 2),
              buildNavItem(Icons.person, 'Profile', 3),
            ],
          ),
        ),
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              backgroundColor: kYellow,
              foregroundColor: Colors.black,
              child: Icon(Icons.post_add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PostBookScreen(
                        onPost: addBook, ownerEmail: widget.userEmail),
                  ),
                );
              },
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget buildNavItem(IconData icon, String label, int index) {
    final selected = index == _selectedIndex;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          color: kDarkNavy,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: selected ? kYellow : Colors.white70),
              SizedBox(height: 4),
              Text(label,
                  style: TextStyle(
                      color: selected ? kYellow : Colors.white70,
                      fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------- Models -------------------

class Book {
  final String id;
  final String title;
  final String author;
  final String condition;
  final String imageUrl;
  final String ownerEmail;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.condition,
    required this.imageUrl,
    required this.ownerEmail,
  });

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? condition,
    String? imageUrl,
    String? ownerEmail,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      condition: condition ?? this.condition,
      imageUrl: imageUrl ?? this.imageUrl,
      ownerEmail: ownerEmail ?? this.ownerEmail,
    );
  }
}

class ChatMessage {
  final String sender;
  final String text;
  final DateTime time;

  ChatMessage({required this.sender, required this.text, DateTime? time})
      : this.time = time ?? DateTime.now();
}

// ------------------- Pages Implementation -------------------

class HomeScreen extends StatelessWidget {
  final List<Book> books;
  final Function(Book) onRequestSwap;

  HomeScreen({required this.books, required this.onRequestSwap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topBar('Browse Listings'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: ListView(
          children: [
            // Featured banner
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 10)],
              ),
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: Colors.white12,
                      width: 90,
                      height: 90,
                      child: Icon(Icons.menu_book, size: 48, color: kYellow),
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('BookSwap',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        SizedBox(height: 6),
                        Text('Swap your books with other students',
                            style: TextStyle(color: Colors.white70)),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => PostBookScreen(
                                        onPost: (b) {
                                          // this route won't directly insert into home: app-level add handled by AppShell
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Posted "${b.title}" (demo)')));
                                        },
                                        ownerEmail: 'demo@example.com')));
                          },
                          child: Text('Post a Book'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text('All Listings',
                style: TextStyle(color: Colors.white70, fontSize: 16)),
            SizedBox(height: 10),
            ...books
                .map((b) => BookCard(book: b, onSwap: () => onRequestSwap(b)))
                .toList(),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onSwap;
  BookCard({required this.book, required this.onSwap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black54,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(book.imageUrl,
              width: 64,
              height: 64,
              fit: BoxFit.cover, errorBuilder: (c, e, s) {
            return Container(
                color: Colors.white12,
                width: 64,
                height: 64,
                child: Icon(Icons.book, color: kYellow));
          }),
        ),
        title: Text(book.title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${book.author} • ${book.condition}',
            style: TextStyle(color: Colors.white70)),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: kYellow, foregroundColor: Colors.black),
          onPressed: onSwap,
          child: Text('Swap'),
        ),
      ),
    );
  }
}

class MyListingsScreen extends StatelessWidget {
  final List<Book> books;
  final String currentUserEmail;
  final Function(Book) onEdit;
  final Function(String) onDelete;

  MyListingsScreen(
      {required this.books,
      required this.currentUserEmail,
      required this.onEdit,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final myBooks =
        books.where((b) => b.ownerEmail == currentUserEmail).toList();
    return Scaffold(
      appBar: topBar('My Listings'),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: myBooks.isEmpty
            ? Center(
                child: Text('No listings yet. Post a book from Home',
                    style: TextStyle(color: Colors.white70)))
            : ListView.builder(
                itemCount: myBooks.length,
                itemBuilder: (context, idx) {
                  final b = myBooks[idx];
                  return Card(
                    color: Colors.black54,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Image.network(b.imageUrl,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover, errorBuilder: (_, __, ___) {
                        return Container(
                            width: 56,
                            height: 56,
                            color: Colors.white12,
                            child: Icon(Icons.book, color: kYellow));
                      }),
                      title: Text(b.title),
                      subtitle: Text('${b.author} • ${b.condition}',
                          style: TextStyle(color: Colors.white70)),
                      trailing: PopupMenuButton<String>(
                        onSelected: (v) {
                          if (v == 'edit') {
                            // open edit form
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return EditBookScreen(
                                  original: b,
                                  onSave: (updated) {
                                    onEdit(updated);
                                  });
                            }));
                          } else if (v == 'delete') {
                            onDelete(b.id);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Deleted "${b.title}"')));
                          }
                        },
                        itemBuilder: (_) => [
                          PopupMenuItem(value: 'edit', child: Text('Edit')),
                          PopupMenuItem(value: 'delete', child: Text('Delete')),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kYellow,
        foregroundColor: Colors.black,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return PostBookScreen(
                onPost: (b) {
                  // In demo, just show snack
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Posted "${b.title}"')));
                },
                ownerEmail: currentUserEmail);
          }));
        },
      ),
    );
  }
}

class PostBookScreen extends StatefulWidget {
  final Function(Book) onPost;
  final String ownerEmail;
  PostBookScreen({required this.onPost, required this.ownerEmail});

  @override
  _PostBookScreenState createState() => _PostBookScreenState();
}

class _PostBookScreenState extends State<PostBookScreen> {
  final titleCtrl = TextEditingController();
  final authorCtrl = TextEditingController();
  String condition = 'Good';
  final imageCtrl = TextEditingController();

  void submit() {
    final title = titleCtrl.text.trim();
    final author = authorCtrl.text.trim();
    final image = imageCtrl.text.trim();
    if (title.isEmpty || author.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill title and author')));
      return;
    }
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final book = Book(
        id: id,
        title: title,
        author: author,
        condition: condition,
        imageUrl: image.isEmpty ? _placeholderImage() : image,
        ownerEmail: widget.ownerEmail);
    widget.onPost(book);
    Navigator.pop(context);
  }

  String _placeholderImage() {
    return 'https://images.unsplash.com/photo-1519681393784-d120267933ba?auto=format&fit=crop&w=400&q=60';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topBar('Post a Book'),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
                controller: titleCtrl,
                decoration:
                    InputDecoration(labelText: 'Book title', filled: true)),
            SizedBox(height: 12),
            TextField(
                controller: authorCtrl,
                decoration: InputDecoration(labelText: 'Author', filled: true)),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: condition,
              items: ['New', 'Like New', 'Good', 'Used']
                  .map((c) => DropdownMenuItem(child: Text(c), value: c))
                  .toList(),
              onChanged: (v) => setState(() => condition = v ?? 'Good'),
              decoration: InputDecoration(labelText: 'Condition', filled: true),
            ),
            SizedBox(height: 12),
            TextField(
                controller: imageCtrl,
                decoration: InputDecoration(
                    labelText: 'Cover Image URL (optional)',
                    hintText: 'Paste Google Drive or image URL',
                    filled: true)),
            SizedBox(height: 18),
            ElevatedButton(onPressed: submit, child: Text('Post')),
          ],
        ),
      ),
    );
  }
}

class EditBookScreen extends StatefulWidget {
  final Book original;
  final Function(Book) onSave;
  EditBookScreen({required this.original, required this.onSave});

  @override
  _EditBookScreenState createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  late TextEditingController titleCtrl;
  late TextEditingController authorCtrl;
  late String condition;
  late TextEditingController imageCtrl;

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.original.title);
    authorCtrl = TextEditingController(text: widget.original.author);
    condition = widget.original.condition;
    imageCtrl = TextEditingController(text: widget.original.imageUrl);
  }

  void save() {
    final updated = widget.original.copyWith(
        title: titleCtrl.text,
        author: authorCtrl.text,
        condition: condition,
        imageUrl: imageCtrl.text);
    widget.onSave(updated);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topBar('Edit Book'),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
                controller: titleCtrl,
                decoration:
                    InputDecoration(labelText: 'Book title', filled: true)),
            SizedBox(height: 12),
            TextField(
                controller: authorCtrl,
                decoration: InputDecoration(labelText: 'Author', filled: true)),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: condition,
              items: ['New', 'Like New', 'Good', 'Used']
                  .map((c) => DropdownMenuItem(child: Text(c), value: c))
                  .toList(),
              onChanged: (v) => setState(() => condition = v ?? 'Good'),
              decoration: InputDecoration(labelText: 'Condition', filled: true),
            ),
            SizedBox(height: 12),
            TextField(
                controller: imageCtrl,
                decoration: InputDecoration(
                    labelText: 'Cover Image URL', filled: true)),
            SizedBox(height: 18),
            ElevatedButton(onPressed: save, child: Text('Save')),
          ],
        ),
      ),
    );
  }
}

// -------------------- Chats --------------------

class ChatsListScreen extends StatelessWidget {
  final Map<String, List<ChatMessage>> chats;
  final Function(String) onOpenThread;
  ChatsListScreen({required this.chats, required this.onOpenThread});

  @override
  Widget build(BuildContext context) {
    final names = chats.keys.toList();
    return Scaffold(
      appBar: topBar('Chats'),
      body: ListView.separated(
        itemCount: names.length,
        separatorBuilder: (_, __) => Divider(color: Colors.white10, height: 1),
        itemBuilder: (context, idx) {
          final name = names[idx];
          final last = chats[name]!.last;
          return ListTile(
            leading: CircleAvatar(
                child: Text(name[0], style: TextStyle(color: Colors.black)),
                backgroundColor: kYellow),
            title: Text(name),
            subtitle:
                Text(last.text, maxLines: 1, overflow: TextOverflow.ellipsis),
            onTap: () => onOpenThread(name),
          );
        },
      ),
    );
  }
}

class ChatThreadScreen extends StatefulWidget {
  final String threadName;
  final List<ChatMessage> messages;
  final Function(ChatMessage) onSend;
  ChatThreadScreen(
      {required this.threadName, required this.messages, required this.onSend});

  @override
  _ChatThreadScreenState createState() => _ChatThreadScreenState();
}

class _ChatThreadScreenState extends State<ChatThreadScreen> {
  final ctrl = TextEditingController();

  void send() {
    final text = ctrl.text.trim();
    if (text.isEmpty) return;
    final msg = ChatMessage(sender: 'You', text: text);
    widget.onSend(msg);
    setState(() {
      widget.messages.add(msg);
    });
    ctrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topBar(widget.threadName),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: widget.messages.length,
              itemBuilder: (context, idx) {
                final m = widget.messages[idx];
                final mine = m.sender == 'You';
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  alignment:
                      mine ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * .7),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    decoration: BoxDecoration(
                      color: mine ? kYellow : Colors.white10,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!mine)
                          Text(m.sender,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.white70)),
                        SizedBox(height: 2),
                        Text(m.text,
                            style: TextStyle(
                                color: mine ? Colors.black : Colors.white)),
                        SizedBox(height: 4),
                        Text(TimeOfDay.fromDateTime(m.time).format(context),
                            style:
                                TextStyle(fontSize: 10, color: Colors.white38)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: Colors.black26,
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                          controller: ctrl,
                          decoration: InputDecoration(
                              hintText: 'Message',
                              filled: true,
                              fillColor: Colors.white10))),
                  SizedBox(width: 8),
                  ElevatedButton(
                      onPressed: send,
                      child: Text('Send'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kYellow,
                          foregroundColor: Colors.black)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

// -------------------- Profile --------------------

class ProfileScreen extends StatelessWidget {
  final String email;
  final VoidCallback onSignOut;
  final VoidCallback onCreatePost;
  ProfileScreen(
      {required this.email,
      required this.onSignOut,
      required this.onCreatePost});

  @override
  Widget build(BuildContext context) {
    bool notifications = true;
    bool emailUpdates = true;
    return Scaffold(
      appBar: topBar('Profile'),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              CircleAvatar(
                  radius: 28,
                  backgroundColor: kYellow,
                  child: Text(email.isNotEmpty ? email[0].toUpperCase() : 'U',
                      style: TextStyle(color: Colors.black))),
              SizedBox(width: 12),
              Expanded(
                  child: Text(email.isNotEmpty ? email : 'demo@example.com',
                      style: TextStyle(fontSize: 16))),
              ElevatedButton(onPressed: onCreatePost, child: Text('Post')),
            ]),
            SizedBox(height: 20),
            Text('Settings',
                style: TextStyle(color: Colors.white70, fontSize: 14)),
            SwitchListTile(
              value: notifications,
              onChanged: (v) {},
              title: Text('Notification reminders'),
            ),
            SwitchListTile(
              value: emailUpdates,
              onChanged: (v) {},
              title: Text('Email Updates'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: onSignOut,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white12,
                  foregroundColor: Colors.white),
              child: Text('Logout'),
            )
          ],
        ),
      ),
    );
  }
}

// -------------------- Utilities --------------------
AppBar topBar(String title) {
  return AppBar(
    title: Text(title),
    backgroundColor: kDarkNavy,
    elevation: 0,
    centerTitle: false,
  );
}
