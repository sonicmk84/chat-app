<?php

namespace App\Events;

use App\Models\Message;
use Illuminate\Broadcasting\Channel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcastNow;
use Illuminate\Queue\SerializesModels;

class MessageSent implements ShouldBroadcastNow
{
    use SerializesModels;

    public function __construct(public Message $message) {}

    public function broadcastOn(): Channel
    {
        // Public channel "chat"
        return new Channel('chat');
    }

    public function broadcastAs(): string
    {
        return 'MessageSent';
    }

    public function broadcastWith(): array
    {
        return [
            'id'        => $this->message->id,
            'content'   => $this->message->content,
            'user'      => [
                'id' => $this->message->user->id,
                'name' => $this->message->user->name,
            ],
            'created_at'=> $this->message->created_at->toISOString(),
        ];
    }
}

