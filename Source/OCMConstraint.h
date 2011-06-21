//---------------------------------------------------------------------------------------
//  $Id: OCMConstraint.h 57M 2010-11-30 05:43:35Z (local) $
//  Copyright (c) 2007-2010 by Mulle Kybernetik. See License file for details.
//---------------------------------------------------------------------------------------

#import <Foundation/Foundation.h>


@interface OCMConstraint : NSObject 

+ (id)constraint;
- (BOOL)evaluate:(id)value;

// if you are looking for any, isNil, etc, they have moved to OCMArg

// try to use [OCMArg checkWith...] instead of the constraintWith... methods below

+ (id)constraintWithSelector:(SEL)aSelector onObject:(id)anObject;
+ (id)constraintWithSelector:(SEL)aSelector onObject:(id)anObject withValue:(id)aValue;


@end

@interface OCMAnyConstraint : OCMConstraint
@end

@interface OCMIsNilConstraint : OCMConstraint
@end

@interface OCMIsNotNilConstraint : OCMConstraint
@end

@interface OCMIsNotEqualConstraint : OCMConstraint
{
	@public
	id testValue;
}

@end

@interface OCMInvocationConstraint : OCMConstraint
{
	@public
	NSInvocation *invocation;
}

@end

@interface OCMBlockConstraint : OCMConstraint
{
	BOOL (^block)(id);
}

- (id)initWithConstraintBlock:(BOOL (^)(id))block;

@end

@interface OCMCaptureConstraint : OCMConstraint
{
  @private
  id argument;
}

- (id)argument;
@end





#define CONSTRAINT(aSelector) [OCMConstraint constraintWithSelector:aSelector onObject:self]
#define CONSTRAINTV(aSelector, aValue) [OCMConstraint constraintWithSelector:aSelector onObject:self withValue:(aValue)]
