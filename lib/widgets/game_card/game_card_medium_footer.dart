import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_entity.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_card/game_card_placeholder_bar.dart';
import 'package:gaming_library_assessment_flutter/widgets/platform_row_list.dart';

import '../../generated/l10n.dart';

class GameCardMediumFooter extends StatelessWidget {
  const GameCardMediumFooter({super.key, this.game, this.onAddTap});

  final GameEntity? game;
  final VoidCallback? onAddTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final game = this.game;
    final onAddTap = this.onAddTap;
    final platforms = game?.platforms;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        SizedBox(
          height: 48,
          child: game == null
              ? const GameCardPlaceholderBar(widthFactor: 0.8)
              : Text(
                  game.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: tokens.typography.body.style.copyWith(
                    color: tokens.color.ink,
                  ),
                ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 18,
          child: game == null
              ? const GameCardPlaceholderBar(widthFactor: 0.5)
              : Text(
                  game.releaseDates?.firstOrNull?.human ??
                      StringConstants.emptyStringPlaceholder,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tokens.typography.meta.style,
                ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 44,
          child: Row(
            children: [
              if (platforms != null && platforms.isNotEmpty)
                Expanded(
                  child: SizedBox(
                    height: 16,
                    child: PlatformRowList(platforms: platforms),
                  ),
                )
              else
                const Spacer(),
              if (onAddTap != null)
                IconButton(
                  onPressed: onAddTap,
                  tooltip: S.current.add_to_library,
                  icon: const Icon(Icons.add),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
