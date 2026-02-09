enum DurationOption {
  s3(3),
  s5(5),
  s8(8),
  s12(12);

  final int seconds;
  const DurationOption(this.seconds);
}
