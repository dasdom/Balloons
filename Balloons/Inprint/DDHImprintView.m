//  Created by Dominik Hauser on 01.01.25.
//  
//


#import "DDHImprintView.h"
#import "DDHCaveScene.h"
#import "DDHStartScene.h"

@interface DDHImprintView () <UITextViewDelegate>
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) DDHStartScene *startScene;
@property (nonatomic, strong) DDHCaveScene *caveScene;
@property (nonatomic, strong) SKView *gameView;
@property (nonatomic) BOOL alreadyStarted;
@end

@implementation DDHImprintView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGRect screenBounds = [UIScreen mainScreen].bounds;
        CGRect gameFrame = CGRectMake(0, 0, screenBounds.size.width, 200);
        _caveScene = [[DDHCaveScene alloc] initWithSize:gameFrame.size];
        _caveScene.scaleMode = SKSceneScaleModeAspectFill;
        _caveScene.anchorPoint = CGPointMake(0.5, 0.5);

        _startScene = [[DDHStartScene alloc] initWithSize:gameFrame.size];

        _gameView = [[SKView alloc] initWithFrame:gameFrame];
        _gameView.ignoresSiblingOrder = YES;
        [_gameView presentScene:_startScene];

        _textView = [[UITextView alloc] init];
        _textView.editable = NO;
        _textView.selectable = NO;
        _textView.decelerationRate = UIScrollViewDecelerationRateFast;
        _textView.text = @"Impressum\nAngaben gemäß § 5 TMG\n\nDominik Hauser\n\nKontakt:\nE-Mail: dominik.hauser ät dasdom punkt de\n\nHaftungsausschluss:\n\nHaftung für Inhalte\n\nDie Inhalte unserer App wurden mit größter Sorgfalt erstellt. Für die Richtigkeit, Vollständigkeit und Aktualität der Inhalte können wir jedoch keine Gewähr übernehmen. Als Diensteanbieter sind wir gemäß § 7 Abs.1 TMG für eigene Inhalte in dieser App nach den allgemeinen Gesetzen verantwortlich. Nach §§ 8 bis 10 TMG sind wir als Diensteanbieter jedoch nicht verpflichtet, übermittelte oder gespeicherte fremde Informationen zu überwachen oder nach Umständen zu forschen, die auf eine rechtswidrige Tätigkeit hinweisen. Verpflichtungen zur Entfernung oder Sperrung der Nutzung von Informationen nach den allgemeinen Gesetzen bleiben hiervon unberührt. Eine diesbezügliche Haftung ist jedoch erst ab dem Zeitpunkt der Kenntnis einer konkreten Rechtsverletzung möglich. Bei Bekanntwerden von entsprechenden Rechtsverletzungen werden wir diese Inhalte umgehend entfernen.\n\nUrheberrecht\n\nDie durch die App-Entwickler erstellten Inhalte und Werke in dieser App unterliegen dem deutschen Urheberrecht. Die Vervielfältigung, Bearbeitung, Verbreitung und jede Art der Verwertung außerhalb der Grenzen des Urheberrechtes bedürfen der schriftlichen Zustimmung des jeweiligen Autors bzw. Erstellers. Downloads und Kopien dieser App sind nur für den privaten, nicht kommerziellen Gebrauch gestattet. Soweit die Inhalte in dieser App nicht vom Betreiber erstellt wurden, werden die Urheberrechte Dritter beachtet. Insbesondere werden Inhalte Dritter als solche gekennzeichnet. Sollten Sie trotzdem auf eine Urheberrechtsverletzung aufmerksam werden, bitten wir um einen entsprechenden Hinweis. Bei Bekanntwerden von Rechtsverletzungen werden wir derartige Inhalte umgehend entfernen.\n\nDatenschutz\n\nEs werden keinerlei Daten erhoben.\n\nImpressum vom Impressum Generator der Kanzlei Hasselbach, Rechtsanwälte für Arbeitsrecht und Familienrecht";
        _textView.delegate = self;

        UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_gameView, _textView]];
        stackView.translatesAutoresizingMaskIntoConstraints = NO;
        stackView.axis = UILayoutConstraintAxisVertical;

        self.backgroundColor = [UIColor systemBackgroundColor];

        [self addSubview:stackView];

        NSLayoutConstraint *gameViewHeightConstraint = [_gameView.heightAnchor constraintEqualToConstant:200];
        gameViewHeightConstraint.priority = 999;

        [NSLayoutConstraint activateConstraints:@[
            [stackView.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor],
            [stackView.leadingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.leadingAnchor],
            [stackView.bottomAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.bottomAnchor],
            [stackView.trailingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.trailingAnchor],

            gameViewHeightConstraint,
        ]];
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.alreadyStarted) {
        CGFloat percentage = scrollView.contentOffset.y / (scrollView.contentSize.height - scrollView.frame.size.height);
        [self.caveScene updatePositionForPercentage:percentage];
    } else {
        self.alreadyStarted = YES;

//        SKTransition *transition = [SKTransition doorsOpenHorizontalWithDuration:5];
//        [self.gameView presentScene:self.caveScene transition:transition];
        [self.gameView presentScene:self.caveScene];

        self.caveScene.scrollSpeed = 1;
    }
}
@end
