//  Created by kawaguchi kohei on 2019/03/17.
//  Copyright © 2019年 kawaguchi kohei. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

final class FollowButton: UIButton, View {
    var disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(reactor: FollowButtonReactor) {
        rx.tap
            .map { Reactor.Action.tapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.isFollowing }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isFollowing in
                self?.backgroundColor = isFollowing ? .red : .blue
                self?.setTitle(isFollowing ? "unfollow" : "follow", for: .normal)
            })
            .disposed(by: disposeBag)
    }

}

final class FollowButtonReactor: Reactor {
    var initialState: State

    enum Action {
        case tapped
    }

    enum Mutation {
        case update(Bool)
    }

    struct State {
        var isFollowing: Bool
    }

    init(isFollowing: Bool) {
        initialState = State(isFollowing: isFollowing)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tapped:
            return .just(Mutation.update(!currentState.isFollowing))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .update(let isFollowing):
            state.isFollowing = isFollowing
        }
        return state
    }
}

