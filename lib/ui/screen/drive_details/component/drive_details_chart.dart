import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../component/gap.dart';
import '../../../component/text.dart';

class DriveDetailsChart extends StatelessWidget {
  final String title;
  final Widget chart;
  final List<DriveDetailsChartDetail> details;

  const DriveDetailsChart({
    super.key,
    required this.title,
    required this.chart,
    this.details = const [],
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleLarge(title),
          const GapVertical8(),
          SizedBox(
            height: 300,
            child: chart,
          ),
          if (details.isNotEmpty) ...[
            const GapVertical8(),
            ...details.map((detail) => _Detail(data: detail)),
          ],
        ],
      );
}

class DriveDetailsChartDetail extends Equatable {
  final String label;
  final String value;

  const DriveDetailsChartDetail({
    required this.label,
    required this.value,
  });

  @override
  List<Object?> get props => [label, value];
}

class _Detail extends StatelessWidget {
  final DriveDetailsChartDetail data;

  const _Detail({
    required this.data,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BodyMedium(
              data.label,
              fontWeight: FontWeight.w300,
            ),
            BodyMedium(
              data.value,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      );
}
