<?php

declare(strict_types=1);

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Mercure\HubInterface;
use Symfony\Component\Mercure\Update;
use Symfony\Component\Routing\Annotation\Route;

class PublishController extends AbstractController
{
    #[Route(path: '/publish', name: 'publish', methods: ['GET'])]
    public function publish(HubInterface $hub): JsonResponse
    {
        // Mercure Resource (should be unique per user)
        $topic = 'demo-topic';

        // Data pushed to the Mercure Resource
        $arrayData = [
            'datetime' => (new \DateTime('now', new \DateTimeZone('UTC')))->format(\DateTime::ATOM),
            'timezone' => 'UTC',
        ];
        $jsonData = json_encode($arrayData, JSON_THROW_ON_ERROR);

        // Mercure Data Wrapper
        $update = new Update($topic, $jsonData);

        // Mercure call
        $hub->publish($update);

        // Confirm data has been published
        return new JsonResponse(json_encode([
            'status' => 'published',
            'topic' => $topic,
            'data' => $arrayData,
        ], JSON_THROW_ON_ERROR));
    }
}
