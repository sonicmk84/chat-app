<x-app-layout>
    <x-slot name="header">
        <h2 class="font-semibold text-xl">Chat</h2>
    </x-slot>

    <div class="py-6">
        <div class="max-w-4xl mx-auto sm:px-6 lg:px-8">
            <div class="bg-white shadow sm:rounded-lg p-4">
                <div id="messages" class="space-y-2 h-80 overflow-y-auto border rounded p-3">
                    @foreach($messages as $m)
                        <div class="text-sm">
                            <span class="font-semibold">{{ $m->user->name }}:</span>
                            <span>{{ $m->content }}</span>
                            <span class="text-xs text-gray-500">({{ $m->created_at->diffForHumans() }})</span>
                        </div>
                    @endforeach
                </div>

                <form id="chat-form" class="mt-4 flex gap-2">
                    @csrf
                    <input type="text" name="content" id="content" class="flex-1 border rounded px-3 py-2" placeholder="Type a message..." required>
                    <button class="bg-blue-600 text-white px-4 py-2 rounded">Send</button>
                </form>
            </div>
        </div>
    </div>

    @vite(['resources/js/app.js'])
</x-app-layout>
