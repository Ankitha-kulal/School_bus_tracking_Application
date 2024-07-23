class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Welcome to School Bus Tracker!",
    image: "assets/images/image11.png",
    desc: "Ensuring your child's safety and convenience on their school journey.",
  ),
  OnboardingContents(
    title: "Track in Real-Time",
    image: "assets/images/image22.gif",
    desc:
        "Get live updates on the location of your child's school bus.",
  ),
  OnboardingContents(
    title: "Stay Informed",
    image: "assets/images/image33.png",
    desc:
        "Receive notifications for bus arrival and departure times.",
  ),
];
