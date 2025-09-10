<?php

namespace App\Http\Controllers;

use App\Events\MessageSent;
use App\Models\Message;
use Illuminate\Http\Request;

class ChatController extends Controller
{
    // Remove this:
    // public function __construct()
    // {
    //     $this->middleware('auth');
    // }

    public function index()
    {
        $messages = Message::with('user')->latest()->limit(50)->get()->reverse()->values();
        return view('chat', compact('messages'));
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'content' => ['required','string','max:2000'],
        ]);

        $message = $request->user()->messages()->create($data);

        broadcast(new MessageSent($message->load('user')));

        return response()->json(['ok' => true, 'message' => $message]);
    }
}
