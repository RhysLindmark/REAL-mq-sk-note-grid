//
//  IIMyScene.m
//  ScrollKit
//
//  Created by Fille Åström on 20/11/13.
//

#import "IIMyScene.h"

typedef NS_ENUM(NSInteger, IIMySceneZPosition)
{
    kIIMySceneZPositionScrolling = 0,
    kIIMySceneZPositionVerticalAndHorizontalScrolling,
    kIIMySceneZPositionStatic,
};

@interface IIMyScene ()
//kIIMySceneZPositionScrolling
@property (nonatomic, weak) SKSpriteNode *spriteToScroll;
@property (nonatomic, weak) SKSpriteNode *spriteForScrollingGeometry;

//kIIMySceneZPositionStatic
@property (nonatomic, weak) SKSpriteNode *spriteForStaticGeometry;

//kIIMySceneZPositionVerticalAndHorizontalScrolling
@property (nonatomic, weak) SKSpriteNode *spriteToHostHorizontalAndVerticalScrolling;
@property (nonatomic, weak) SKSpriteNode *spriteForHorizontalScrolling;
@property (nonatomic, weak) SKSpriteNode *spriteForVerticalScrolling;
@end

@implementation IIMyScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {

        [self setAnchorPoint:(CGPoint){0,1}];
        SKSpriteNode *spriteToScroll = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:size];
        [spriteToScroll setAnchorPoint:(CGPoint){0,1}];
        [spriteToScroll setZPosition:kIIMySceneZPositionScrolling];
        [self addChild:spriteToScroll];

        //Overlay sprite to make anchor point 0,0 (lower left, default for SK)
        SKSpriteNode *spriteForScrollingGeometry = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:size];
        [spriteForScrollingGeometry setAnchorPoint:(CGPoint){0,0}];
        [spriteForScrollingGeometry setPosition:(CGPoint){0, -size.height}];
        [spriteToScroll addChild:spriteForScrollingGeometry];

        SKSpriteNode *spriteForStaticGeometry = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:size];
        [spriteForStaticGeometry setAnchorPoint:(CGPoint){0,0}];
        [spriteForStaticGeometry setPosition:(CGPoint){0, -size.height}];
        [spriteForStaticGeometry setZPosition:kIIMySceneZPositionStatic];
        [self addChild:spriteForStaticGeometry];

        SKSpriteNode *spriteToHostHorizontalAndVerticalScrolling = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:size];
        [spriteToHostHorizontalAndVerticalScrolling setAnchorPoint:(CGPoint){0,0}];
        [spriteToHostHorizontalAndVerticalScrolling setPosition:(CGPoint){0, -size.height}];
        [spriteToHostHorizontalAndVerticalScrolling setZPosition:kIIMySceneZPositionVerticalAndHorizontalScrolling];
        [self addChild:spriteToHostHorizontalAndVerticalScrolling];

        CGSize upAndDownSize = size;
        upAndDownSize.width = 30;
        SKSpriteNode *spriteForVerticalScrolling = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:upAndDownSize];
        [spriteForVerticalScrolling setAnchorPoint:(CGPoint){0,0}];
        [spriteForVerticalScrolling setPosition:(CGPoint){0,30}];
        [spriteToHostHorizontalAndVerticalScrolling addChild:spriteForVerticalScrolling];

        CGSize leftToRightSize = size;
        leftToRightSize.height = 30;
        SKSpriteNode *spriteForHorizontalScrolling = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:leftToRightSize];
        [spriteForHorizontalScrolling setAnchorPoint:(CGPoint){0,0}];
        [spriteForHorizontalScrolling setPosition:(CGPoint){10,0}];
        [spriteToHostHorizontalAndVerticalScrolling addChild:spriteForHorizontalScrolling];

        //Test sprites for constrained Scrolling
        CGFloat labelPosition = -500.0;
        CGFloat stepSize = 50.0;
        while (labelPosition < 2000.0)
        {
            NSString *labelText = [NSString stringWithFormat:@"%5.0f", labelPosition];

            SKLabelNode *scrollingLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
            [scrollingLabel setText:labelText];
            [scrollingLabel setFontSize:14.0];
            [scrollingLabel setFontColor:[SKColor darkGrayColor]];
            [scrollingLabel setPosition:(CGPoint){.x = 0.0, .y = labelPosition}];
            [scrollingLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeLeft];
            [spriteForHorizontalScrolling addChild:scrollingLabel];

            scrollingLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
            [scrollingLabel setText:labelText];
            [scrollingLabel setFontSize:14.0];
            [scrollingLabel setFontColor:[SKColor darkGrayColor]];
            [scrollingLabel setPosition:(CGPoint){.x = labelPosition, .y = 0.0}];
            [scrollingLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeLeft];
            [scrollingLabel setZPosition:kIIMySceneZPositionVerticalAndHorizontalScrolling];
            [spriteForVerticalScrolling addChild:scrollingLabel];
            labelPosition += stepSize;
        }
        
        int spriteSize = 20;
        int numberOfSprites = 50;
        CGPathRef path = CGPathCreateWithRoundedRect(CGRectMake(-15, -15, 30, 30), 4, 4, nil);
        for (int i = 0; i < numberOfSprites; i++)
        {
            for (int j = 0; j < numberOfSprites; j++)
            {
                //Test sprites for scrolling and zooming
                SKEffectNode *effectNode = [[SKEffectNode alloc] init];
                SKShapeNode *greenTestSprite = [SKShapeNode shapeNodeWithRect:CGRectMake(0, 0, spriteSize, spriteSize) cornerRadius:3];
                [greenTestSprite setFillColor:[UIColor redColor]];
                [effectNode addChild:greenTestSprite];
                effectNode.shouldRasterize = YES;
                
                
                [greenTestSprite setName:@"greenTestSprite"];
                [greenTestSprite setPosition:(CGPoint){.x = i * spriteSize * 2, .y = j * spriteSize * 2}];
                [spriteForScrollingGeometry addChild:effectNode];
            }
            
            
            SKSpriteNode *blueTestSprite = [SKSpriteNode spriteNodeWithColor:[SKColor blueColor]
                                                                        size:(CGSize){.width = size.width*.25,
                                                                            .height = size.height*.25}];
            [blueTestSprite setName:@"blueTestSprite"];
            [blueTestSprite setAnchorPoint:(CGPoint){0,0}];
            [blueTestSprite setPosition:(CGPoint){.x = size.width * .25 + i * 25, .y = size.height *.65 + i * 25}];
            [spriteForScrollingGeometry addChild:blueTestSprite];
            
            //Test sprites for stationary sprites
            SKLabelNode *stationaryLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
            [stationaryLabel setText:@"I'm not gonna move, nope, nope."];
            [stationaryLabel setFontSize:14.0];
            [stationaryLabel setFontColor:[SKColor darkGrayColor]];
            [stationaryLabel setPosition:(CGPoint){.x = 60.0 + i, .y = 60.0 + i}];
            [stationaryLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeLeft];
            [spriteForStaticGeometry addChild:stationaryLabel];
        }
        

        //Set properties
        _contentSize = size;
        _spriteToScroll = spriteToScroll;
        _spriteForScrollingGeometry = spriteForScrollingGeometry;
        _spriteForStaticGeometry = spriteForStaticGeometry;
        _spriteToHostHorizontalAndVerticalScrolling = spriteToHostHorizontalAndVerticalScrolling;
        _spriteForVerticalScrolling = spriteForVerticalScrolling;
        _spriteForHorizontalScrolling = spriteForHorizontalScrolling;
        _contentOffset = (CGPoint){0,0};
    }
    return self;
}

- (void)handleTapAtPoint:(CGPoint)point
{
    point = CGPointMake(point.x, _contentSize.height - point.y);
    NSLog(@"%@", NSStringFromCGPoint(point));
    SKEffectNode *effectNode = [[SKEffectNode alloc] init];
    SKShapeNode *greenTestSprite = [SKShapeNode shapeNodeWithRect:CGRectMake(0, 0, 100, 100) cornerRadius:25];
    [greenTestSprite setFillColor:[UIColor redColor]];
    [effectNode addChild:greenTestSprite];
    effectNode.shouldRasterize = YES;
    
    [greenTestSprite setName:@"greenTestSprite"];
    [greenTestSprite setPosition:point];
    [self.spriteForScrollingGeometry addChild:effectNode];
    
    [NSTimer scheduledTimerWithTimeInterval:.25 target:self selector:@selector(scrollMe) userInfo:nil repeats:YES];
}

- (void)scrollMe
{
    CGPoint contentOffset = (CGPoint){_contentOffset.x + 20, _contentOffset.y};
    _contentOffset = contentOffset;
    contentOffset.x *= -1;
    [self.spriteToScroll runAction:[SKAction moveTo:contentOffset duration:.25]];
//    [self.spriteToScroll setPosition:contentOffset];
    
    CGPoint scrollingLowerLeft = [self.spriteForScrollingGeometry convertPoint:(CGPoint){0,0} toNode:self.spriteToHostHorizontalAndVerticalScrolling];
    
    CGPoint horizontalScrollingPosition = [self.spriteForHorizontalScrolling position];
    horizontalScrollingPosition.y = scrollingLowerLeft.y;
    
    
    [self.spriteForHorizontalScrolling runAction:[SKAction moveTo:horizontalScrollingPosition duration:.25]];
//    [self.spriteForHorizontalScrolling setPosition:horizontalScrollingPosition];
    
    CGPoint verticalScrollingPosition = [self.spriteForVerticalScrolling position];
    verticalScrollingPosition.x = scrollingLowerLeft.x;
    [self.spriteForVerticalScrolling runAction:[SKAction moveTo:verticalScrollingPosition duration:.25]];
//    [self.spriteForVerticalScrolling setPosition:verticalScrollingPosition];
    
    
    
    

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInNode:self.spriteForScrollingGeometry];

    SKEffectNode *effectNode = [[SKEffectNode alloc] init];
    SKShapeNode *greenTestSprite = [SKShapeNode shapeNodeWithRect:CGRectMake(0, 0, 100, 100) cornerRadius:25];
    [greenTestSprite setFillColor:[UIColor redColor]];
    [effectNode addChild:greenTestSprite];
    effectNode.shouldRasterize = YES;
    
    [greenTestSprite setName:@"greenTestSprite"];
    [greenTestSprite setPosition:touchPoint];
    [self.spriteForScrollingGeometry addChild:effectNode];
}

-(void)didChangeSize:(CGSize)oldSize
{
    CGSize size = [self size];

    CGPoint lowerLeft = (CGPoint){0, -size.height};

    [self.spriteForStaticGeometry setSize:size];
    [self.spriteForStaticGeometry setPosition:lowerLeft];

    [self.spriteToHostHorizontalAndVerticalScrolling setSize:size];
    [self.spriteToHostHorizontalAndVerticalScrolling setPosition:lowerLeft];
}

-(void)setContentSize:(CGSize)contentSize
{
    if (!CGSizeEqualToSize(contentSize, _contentSize))
    {
        _contentSize = contentSize;
        [self.spriteToScroll setSize:contentSize];
        [self.spriteForScrollingGeometry setSize:contentSize];
        [self.spriteForScrollingGeometry setPosition:(CGPoint){0, -contentSize.height}];
        [self updateConstrainedScrollerSize];
    }
}

-(void)setContentOffset:(CGPoint)contentOffset
{
    _contentOffset = contentOffset;
    contentOffset.x *= -1;
    [self.spriteToScroll setPosition:contentOffset];

    CGPoint scrollingLowerLeft = [self.spriteForScrollingGeometry convertPoint:(CGPoint){0,0} toNode:self.spriteToHostHorizontalAndVerticalScrolling];

    CGPoint horizontalScrollingPosition = [self.spriteForHorizontalScrolling position];
    horizontalScrollingPosition.y = scrollingLowerLeft.y;

    [self.spriteForHorizontalScrolling setPosition:horizontalScrollingPosition];

    CGPoint verticalScrollingPosition = [self.spriteForVerticalScrolling position];
    verticalScrollingPosition.x = scrollingLowerLeft.x;
    [self.spriteForVerticalScrolling setPosition:verticalScrollingPosition];
}

-(void)setContentScale:(CGFloat)scale;
{
    [self.spriteToScroll setScale:scale];
    [self updateConstrainedScrollerSize];
}

-(void)updateConstrainedScrollerSize
{

    CGSize contentSize = [self contentSize];
    CGSize verticalSpriteSize = [self.spriteForVerticalScrolling size];
    verticalSpriteSize.height = contentSize.height;
    [self.spriteForVerticalScrolling setSize:verticalSpriteSize];

    CGSize horizontalSpriteSize = [self.spriteForHorizontalScrolling size];
    horizontalSpriteSize.width = contentSize.width;
    [self.spriteForHorizontalScrolling setSize:horizontalSpriteSize];

    CGFloat xScale = [self.spriteToScroll xScale];
    CGFloat yScale = [self.spriteToScroll yScale];
    [self.spriteForVerticalScrolling setYScale:yScale];
    [self.spriteForVerticalScrolling setXScale:xScale];
    [self.spriteForHorizontalScrolling setXScale:xScale];
    [self.spriteForHorizontalScrolling setYScale:yScale];
    CGFloat xScaleReciprocal = 1.0/xScale;
    CGFloat yScaleReciprocal = 1/yScale;
    for (SKNode *node in [self.spriteForVerticalScrolling children])
    {
        [node setXScale:xScaleReciprocal];
        [node setYScale:yScaleReciprocal];
    }
    for (SKNode *node in [self.spriteForHorizontalScrolling children])
    {
        [node setXScale:xScaleReciprocal];
        [node setYScale:yScaleReciprocal];
    }

    [self setContentOffset:self.contentOffset];
}



@end
