<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use MongoDB\Laravel\Eloquent\Model as AuthenticatableMongoDB;

class User extends AuthenticatableMongoDB
{
    use HasApiTokens, HasFactory, Notifiable;

    protected $connection = 'mongodb';
    protected $collection = 'user';
    protected $fillable = [
        'id', 
        'name', 
        'surname', 
        'street', 
        'company', 
        'username', 
        'e-mail', 
        'password', 
        'plan', 
        'job_backup_date', 
        'last_backup_date' , 
        'active'
    ];
    public $timestamps = false;
}
