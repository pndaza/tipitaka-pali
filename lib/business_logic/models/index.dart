class Index {
  final int _pageID;
  final int _position;
  String? bookID;

  Index(this._pageID, this._position, [this.bookID]);

  int get pageID {
    return _pageID;
  }

  int get position {
    return _position;
  }

}