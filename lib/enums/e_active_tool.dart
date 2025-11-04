enum ActiveTool {
  selectTool(1, "select"),
  penTool(2, "pen");

  final int number;
  final String shortName;

  const ActiveTool(this.number, this.shortName);
}

enum KeyStyle {
  normal(1, "normal"),
  normalWholeSecond(2, "normalWholeSecond"),
  highlight(3, "highlight"),
  keyed(4, "keyed"),
  keyedHighlight(5, "keyedHighlight");

  final int number;
  final String shortName;

  const KeyStyle(this.number, this.shortName);
}
