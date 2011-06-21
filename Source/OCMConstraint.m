//---------------------------------------------------------------------------------------
//  $Id: OCMConstraint.m 57M 2010-11-30 05:43:35Z (local) $
//  Copyright (c) 2007-2010 by Mulle Kybernetik. See License file for details.
//---------------------------------------------------------------------------------------

#import <OCMock/OCMConstraint.h>


@implementation OCMConstraint

+ (id)constraint
{
	return [[[self alloc] init] autorelease];
}

- (BOOL)evaluate:(id)value
{
	return NO;
}


+ (id)constraintWithSelector:(SEL)aSelector onObject:(id)anObject
{
	OCMInvocationConstraint *constraint = [OCMInvocationConstraint constraint];
	NSMethodSignature *signature = [anObject methodSignatureForSelector:aSelector]; 
	if(signature == nil)
		[NSException raise:NSInvalidArgumentException format:@"Unkown selector %@ used in constraint.", NSStringFromSelector(aSelector)];
	NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
	[invocation setTarget:anObject];
	[invocation setSelector:aSelector];
	constraint->invocation = invocation;
	return constraint;
}

+ (id)constraintWithSelector:(SEL)aSelector onObject:(id)anObject withValue:(id)aValue
{
	OCMInvocationConstraint *constraint = [self constraintWithSelector:aSelector onObject:anObject];
	if([[constraint->invocation methodSignature] numberOfArguments] < 4)
		[NSException raise:NSInvalidArgumentException format:@"Constraint with value requires selector with two arguments."];
	[constraint->invocation setArgument:&aValue atIndex:3];
	return constraint;
}


@end



#pragma mark  -

@implementation OCMAnyConstraint

- (BOOL)evaluate:(id)value
{
	return YES;
}

@end



#pragma mark  -

@implementation OCMIsNilConstraint

- (BOOL)evaluate:(id)value
{
	return value == nil;
}

@end



#pragma mark  -

@implementation OCMIsNotNilConstraint

- (BOOL)evaluate:(id)value
{
	return value != nil;
}

@end



#pragma mark  -

@implementation OCMIsNotEqualConstraint

- (BOOL)evaluate:(id)value
{
	return ![value isEqual:testValue];
}

@end



#pragma mark  -

@implementation OCMInvocationConstraint

- (BOOL)evaluate:(id)value
{
	[invocation setArgument:&value atIndex:2]; // should test if constraint takes arg
	[invocation invoke];
	BOOL returnValue;
	[invocation getReturnValue:&returnValue];
	return returnValue;
}

@end

#pragma mark  -

@implementation OCMBlockConstraint

- (id)initWithConstraintBlock:(BOOL (^)(id))aBlock;
{
	[super init];
	block = aBlock;
	return self;
}

- (BOOL)evaluate:(id)value 
{
	return block(value);
}

@end

#pragma mark -

@implementation OCMCaptureConstraint

- (BOOL)evaluate:(id)value
{  
  if ([value isKindOfClass:NSClassFromString(@"__NSStackBlock__")]) {
    argument = [value copy];
  } else {
    argument = [value retain];    
  }
  return YES;
}

- (id)argument {
  if (argument == nil) {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Argument requested from OCMCaptureConstraint has yet to be captured." userInfo:nil];
  }
  
  return argument;
}

- (void)dealloc {
  [argument release]; argument = nil;
  [super dealloc];
}

@end
