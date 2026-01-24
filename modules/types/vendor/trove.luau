export type Trove = {
	Extend: (self: Trove) -> Trove,
	Clone: <T>(self: Trove, instance: T & Instance) -> T,
	Construct: <T, A...>(self: Trove, class: Constructable<T, A...>, A...) -> T,
	Connect: (
		self: Trove,
		signal: SignalLike | SignalLikeMetatable | RBXScriptSignal,
		fn: (...any) -> ...any
	) -> ConnectionLike | ConnectionLikeMetatable,
	BindToRenderStep: (self: Trove, name: string, priority: number, fn: (dt: number) -> ()) -> (),
	AddPromise: <T>(self: Trove, promise: (T & PromiseLike) | (T & PromiseLikeMetatable)) -> T,
	Add: <T>(self: Trove, object: T & Trackable, cleanupMethod: string?) -> T,
	Remove: <T>(self: Trove, object: T & Trackable) -> boolean,
	Pop: <T>(self: Trove, object: T & Trackable) -> boolean,
	Clean: (self: Trove) -> (),
	WrapClean: (self: Trove) -> () -> (),
	AttachToInstance: (self: Trove, instance: Instance) -> RBXScriptConnection,
	Destroy: (self: Trove) -> (),
}

export type TroveInternal = Trove & {
	_objects: { any },
	_cleaning: boolean,
	_findAndRemoveFromObjects: (self: TroveInternal, object: any, cleanup: boolean) -> boolean,
	_cleanupObject: (self: TroveInternal, object: any, cleanupMethod: string?) -> (),
}

export type Trackable =
	| Instance
	| RBXScriptConnection
	| ConnectionLike
	| ConnectionLikeMetatable
	| PromiseLike
	| PromiseLikeMetatable
	| thread
	| ((...unknown) -> ...unknown)
	| (() -> ())
	| Destroyable
	| DestroyableMetatable
	| DestroyableLowercase
	| DestroyableLowercaseMetatable
	| Disconnectable
	| DisconectableMetatable
	| DisconnectableLowercase
	| DisconnectableLowercaseMetatable
	| SignalLike
	| SignalLikeMetatable

export type ConnectionLike = {
	Connected: boolean,
	Disconnect: (self: ConnectionLike) -> (),
}

export type ConnectionLikeMetatable = typeof(setmetatable(
	{},
	{} :: { Connected: boolean, Disconnect: (self: ConnectionLikeMetatable) -> () }
))

export type SignalLike = {
	Connect: (self: SignalLike, callback: (...any) -> ...any) -> ConnectionLike | ConnectionLikeMetatable,
	Once: (self: SignalLike, callback: (...any) -> ...any) -> ConnectionLike | ConnectionLikeMetatable,
}

export type SignalLikeMetatable = typeof(setmetatable(
	{},
	{} :: {
		Connect: (self: SignalLikeMetatable, callback: (...any) -> ...any) -> ConnectionLike | ConnectionLikeMetatable,
		Once: (self: SignalLikeMetatable, callback: (...any) -> ...any) -> ConnectionLike | ConnectionLikeMetatable,
	}
))

export type PromiseLike = {
	getStatus: (self: PromiseLike) -> string,
	finally: (self: PromiseLike, callback: (...any) -> ...any) -> PromiseLike | PromiseLikeMetatable,
	cancel: (self: PromiseLike) -> (),
}

export type PromiseLikeMetatable = typeof(setmetatable(
	{},
	{} :: {
		getStatus: (self: any) -> string,
		finally: (self: PromiseLikeMetatable, callback: (...any) -> ...any) -> PromiseLike | PromiseLikeMetatable,
		cancel: (self: PromiseLikeMetatable) -> (),
	}
))

export type Constructable<T, A...> = { new: (A...) -> T } | (A...) -> T

export type Destroyable = {
	Destroy: (self: Destroyable) -> (),
}

export type DestroyableMetatable = setmetatable<{}, { destroy: (self: Destroyable) -> () }>

export type DestroyableLowercase = {
	destroy: (self: DestroyableLowercase) -> (),
}

export type DestroyableLowercaseMetatable = setmetatable<{}, { destroy: (self: DestroyableLowercaseMetatable) -> () }>

export type Disconnectable = {
	Disconnect: (self: Disconnectable) -> (),
}

export type DisconectableMetatable = setmetatable<{}, { Disconnect: (self: DisconectableMetatable) -> () }>

export type DisconnectableLowercase = {
	disconnect: (self: DisconnectableLowercase) -> (),
}

export type DisconnectableLowercaseMetatable = setmetatable<
	{},
	{ disconnect: (self: DisconnectableLowercaseMetatable) -> () }
>

return nil
