enum ActiveTool {
  selectTool(1, "select"),
  penTool(2, "pen");

  final int number;
  final String shortName;

  const ActiveTool(this.number, this.shortName);
}
