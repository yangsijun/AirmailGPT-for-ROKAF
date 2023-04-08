import 'package:airmail_gpt_client/src/view.dart';

import 'package:skeletons/skeletons.dart';

class AiEditPageSkeleton extends StatelessWidget {
  const AiEditPageSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SkeletonItem(
      child: SingleChildScrollView(
        child: Center(
          child: SetState(
            builder: (context, dataObject) => Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        // TextFormField (airman name)
                        child: SkeletonLine(
                          style: SkeletonLineStyle(
                            height: 56,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        // TextFormField (airman birth)
                        child: SkeletonLine(
                          style: SkeletonLineStyle(
                            height: 56,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        // TextFormField (sender name)
                        child: SkeletonLine(
                          style: SkeletonLineStyle(
                            height: 56,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        // TextFormField (relationship)
                        child: SkeletonLine(
                          style: SkeletonLineStyle(
                            height: 56,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // TextFormField (password)
                  SkeletonLine(
                    style: SkeletonLineStyle(
                      height: 56,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // TextFormField (address)
                  SkeletonLine(
                    style: SkeletonLineStyle(
                      height: 104,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  // TextFormField (title)
                  SkeletonLine(
                    style: SkeletonLineStyle(
                      height: 56,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // TextFormField (content)
                  SkeletonLine(
                    style: SkeletonLineStyle(
                      height: 272,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // FilledButton (send)
                  SkeletonLine(
                    style: SkeletonLineStyle(
                      height: 32,
                      borderRadius: BorderRadius.circular(16),
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