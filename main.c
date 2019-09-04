#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define TRUE 1
#define FALSE 0
// constantes
#define TRUCK_TAX 25
#define CAR_TAX 10
#define BIKE_TAX 6

typedef struct _client_{
    int id, arrival, departure;
    float amount;
    int plate;
    char vehicle[20];
}Client;

typedef struct _parking_slots{
    int size;
    int free;
    struct _client_ **clients;
}Park;

Park* park = NULL;

void create_empty_park(int size)
{
    park = (Park*)malloc(sizeof(Park));
    park->clients = (Client**)malloc(sizeof(Client*)*size);
    for(int i=0;i<size;i++){
        park->clients[i] = NULL;
    }
    park->size = size;
    park->free = size;
}

void destroy_park()
{
    int i;
    for(i=0;i<park->size;i++){
        if(park->clients[i]!=NULL) free(park->clients[i]);
    }
    free(park->clients);
    free(park);
}
// não implementada
float get_time()
{
    return -1.0;
}

int check_spots()
{
    if(park->free == 0) return FALSE;
    else return TRUE;
}

Client* fill_new_client(Client* client)
{
    client = (Client*)malloc(sizeof(Client));
    printf("\nPlate?: ");
    scanf("%d",&client->plate);
    printf("\nVehicle?: ");
    scanf("%s",client->vehicle);
    client->id = plate % park->size;
    client->arrival = get_time();
    client->departure = -1;
    client->amount = 0;
    return client;
}

int register_new_client()
{
    Client *temp = NULL;
    if(check_spots()){
        temp = fill_new_client(temp);
        park->clients[temp->spot] = temp;
        park->free--;
        return TRUE;
    }
    else{
        printf("No spots avaible!\n");
        return FALSE;
    }
}

void get_ticket(Client* client)
{
    printf("Scope\n");
}

// incompleta
int checkout()
{
    int temp_plate, temp_id;
    Client* temp_client;
    printf("Plate?: ");
    scanf("%d",&temp_plate);
    temp_id = temp_plate % park->size;
    temp_client = park->clients[temp_id];
    get_ticket(temp_client);
}
// incompleta
void menu()
{
    printf("1 - Cadastrar\n");
    printf("2 - Pagar\n");
    printf("3 - Buscar\n");
}

int main(int argc, char* argv[])
{
    create_empty_park(1000);
}
